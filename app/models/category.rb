class Category < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: true

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: [:create, :update]

  private

  def generate_slug
    self.slug ||= name.parameterize
  end
end
