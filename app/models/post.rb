class Post < ApplicationRecord
  belongs_to :customer
  has_many_attached :images
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :notifications, dependent: :destroy

  # タイトルが空欄でないことを確認している
  validates :title, presence: true
  # 投稿の説明が空欄でないことを確認している
  validates :body, presence: true

  # 検索方向分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

  def create_notification_by(current_customer)
	    notification = current_customer.active_notifications.new(
	      post_id: id,
	      visited_id: customer_id,
	      action: "favorite"
	    )
	    notification.save if notification.valid?
  end

  def create_notification_comment!(current_customer, comment_id)
	    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
	    temp_ids = Comment.select(:customer_id).where(post_id: id).where.not(customer_id: current_customer.id).distinct
	    temp_ids.each do |temp_id|
	        save_notification_comment!(current_customer, comment_id, temp_id['customer_id'])
      end
    	# まだ誰もコメントしていない場合は、投稿者に通知を送る
    	save_notification_comment!(current_customer, comment_id, customer_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_customer, comment_id, visited_id)
      # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
      notification = current_customer.active_notifications.new(
        post_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
        )
        # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.visiter_id == notification.visited_id
          notification.checked = true
      end
        notification.save if notification.valid?
  end

end
