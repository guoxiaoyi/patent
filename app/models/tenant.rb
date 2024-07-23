class Tenant < ApplicationRecord
  validates :name, presence: true
  validates :subdomain, uniqueness: true, allow_blank: true
  validates :domain, uniqueness: true, allow_blank: true
  validate :subdomain_or_domain_present

  private

  def subdomain_or_domain_present
    if subdomain.blank? && domain.blank?
      errors.add(:base, "Either subdomain or domain must be present")
    end
  end
end
