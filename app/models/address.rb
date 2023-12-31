class Address < ApplicationRecord
  has_many :users
  has_many :contacts

  def self.create_from_cep(cep)
    address_data = ViaCepService.fetch_address(cep)

    address = find_or_create_by(cep: address_data['cep'].gsub('-', '')) do |addr|
      addr.street = address_data['logradouro']
      addr.city = address_data['localidade']
      addr.state = address_data['uf']
      addr.neighborhood = address_data['bairro']
    end

    if address.persisted?
      address
    else
      Rails.logger.error "Failed to save address: #{address.errors.full_messages.join(', ')}"
      nil
    end
  end

  def self.find_or_create_by_details(uf, city, street)
    addresses = ViaCepService.by_city_and_address(uf, city, street)
    address_data = addresses.first

    find_or_create_by(cep: address_data['cep'].gsub('-', '')) do |addr|
      addr.street = address_data['logradouro']
      addr.city = address_data['localidade']
      addr.state = address_data['uf']
      addr.neighborhood = address_data['bairro']
    end
  end
end
