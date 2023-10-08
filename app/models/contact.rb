class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :address

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validate :cpf_must_be_valid
  validates :phone, presence: true
  validates :street_number, presence: true

  def cpf_must_be_valid
    errors.add(:cpf, 'Invalid CPF') unless CpfValidatorService.valid?(cpf)
  end
end
