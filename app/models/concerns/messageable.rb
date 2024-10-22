# app/models/concerns/messageable.rb
module Messageable
  extend ActiveSupport::Concern

  def messages
    @criteria ||= Message.where("#{self.class.name.underscore}_id": id)
  end
end
