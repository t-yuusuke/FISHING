class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # 名前が空でないことを確認している
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  # メールアドレスが空でないことを確認している
  validates :email, presence: true

  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visiter_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy


  # フォローをしたときの処理
  def follow(customer_id)
    relationships.create(followed_id: customer_id)
  end
  # フォローを外すしたときの処理
  def unfollow(customer_id)
    relationships.find_by(followed_id: customer_id).destroy
  end
  # フォローしているか判断する
  def following?(customer)
    followings.include?(customer)
  end

  # 検索方向分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @customer = Customer.where("last_name LIKE?", "#{word}")
    elsif search == "forward_match"
      @customer = Customer.where("last_name LIKE?","#{word}%")
    elsif search == "backward_match"
      @customer = Customer.where("first_name LIKE?","%#{word}")
    elsif search == "partial_match"
      @customer = Customer.where("last_name LIKE?","%#{word}%")
    else
      @customer = Customer.all
    end
  end

  def full_name
    self.last_name+""+self.first_name
  end

  def full_name_kana
    self.last_name_kana+""+self.first_name_kana
  end

  def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/No-picture.png')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
  end
  #ゲストのメソッドを定義している
  def self.guest
    find_or_create_by!(last_name: 'guestuser' ,first_name: 'guestuser' ,last_name_kana: 'guestuser' ,first_name_kana: 'guestuser' ,email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.last_name = "guestuser"
    end
  end


end
