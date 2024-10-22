# app/models/conversation.rb
class Conversation < ApplicationRecord
  include Messageable  
  before_create :generate_uuid

  belongs_to :user
  belongs_to :feature
  belongs_to :tenant
  
  private

  def generate_uuid
    self.id = SecureRandom.uuid if self.id.blank?
  end
end
