class User < ApplicationRecord
  belongs_to :address
  has_many :contacts, dependent: :destroy
  has_secure_password
  before_validation :set_address_from_cep

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :cpf, presence: true, uniqueness: true
  validate :cpf_must_be_valid
  validates :phone, presence: true
  validates :street_number, presence: true
  validates :cep, presence: true

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
    errors.add(:cep, "Failed to process cep  #{e.message}")
    throw(:abort)
  end

  def cpf_must_be_valid
    errors.add(:cpf, 'Invalid CPF') unless CpfValidatorService.valid?(cpf)
  end
end
