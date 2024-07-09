class VerificationCode < ApplicationRecord
  before_create :generate_code

  def generate_code
    self.code = rand.to_s[2..7]
  end
end
