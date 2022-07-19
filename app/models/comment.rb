class Comment < ApplicationRecord
  belongs_to :customer
  belongs_to :post

  # コメントが空欄でないことを確認している
  validates :comment, presence: true

end
