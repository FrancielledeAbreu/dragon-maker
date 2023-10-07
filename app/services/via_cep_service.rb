require 'httparty'
require 'cgi'

class ViaCepService
  include HTTParty
  base_uri 'https://viacep.com.br/ws'

  def self.fetch_address(cep)
    url = "#{base_uri}/#{cep}/json"
    get("#{url}")
  end

  def self.by_city_and_address(uf, city, address)
    url = "#{base_uri}/#{uf}/#{CGI.escape(city).gsub('+', '%20')}/#{CGI.escape(address).gsub('+', '%20')}/json"
    response = get(url)
    Rails.logger.info "Response from ViaCepService: #{response}"
    response.parsed_response
  end
end
