class Post < ApplicationRecord
  belongs_to :customer
  has_many_attached :images
  has_many :favorites, dependent: :destroy

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
  
end
