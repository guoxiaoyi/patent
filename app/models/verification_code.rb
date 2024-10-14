class VerificationCode < ApplicationRecord
  before_create :generate_code

  def generate_code
    if Rails.env.development?
      self.code = '123456'
    else
      self.code = rand.to_s[2..7]
    end
  end
end
