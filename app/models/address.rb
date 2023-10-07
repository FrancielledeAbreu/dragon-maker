class Address < ApplicationRecord
  has_many :users

  def self.create_from_cep(cep)
    address_data = ViaCepService.fetch_address(cep).parsed_response

    puts "Address Data: #{address_data.inspect}"

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
end
