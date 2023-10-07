require 'httparty'

class ViaCepService
  include HTTParty
  base_uri 'https://viacep.com.br/ws'

  def self.fetch_address(cep)
    url = "#{base_uri}/#{cep}/json"
    response = get("#{url}")
    Rails.logger.info "url v v: #{url}"
    Rails.logger.info "Response from ViaCepService: #{response}"
    response
  end
end
