class User < ApplicationRecord
  belongs_to :address
  has_secure_password
  before_validation :set_address_from_cep

  private

  def set_address_from_cep
    created_address = Address.create_from_cep(cep)
    if created_address
      self.address = created_address
    else
      errors.add(:cep, 'Failed to process cep')
      throw(:abort)
    end
  rescue StandardError => e
    Rails.logger.error "Failed to create address: #{e.message}"
    errors.add(:cep, 'Failed to process cep')
    throw(:abort)
  end
end
