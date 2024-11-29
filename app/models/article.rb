class Article < ApplicationRecord
  belongs_to :category

  enum status: { draft: 0, published: 1 }

  validates :title, :content, :author, :category, presence: true
end
