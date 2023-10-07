class Api::V1::AddressesController < AuthenticatedController
  before_action :authorized, only: [:search_by_cep]

  def search
    results = ViaCepService.by_city_and_address(params[:uf], params[:city], params[:street])

    if results.empty?
      render_error('No addresses found')
    else
      addresses = results.map { |result| find_or_create_address(result) }
      render json: addresses, status: :ok
    end
  end

  def search_by_cep
    result = ViaCepService.fetch_address(params[:cep])

    if result && result['erro'] != true
      address = find_or_create_address(result)
      render json: address, status: :ok
    else
      render_error('Address not found')
    end
  end

  private

  def render_error(message)
    render json: { error: message }, status: :not_found
  end

  def find_or_create_address(result)
    Address.find_or_create_by(cep: result['cep']) do |addr|
      addr.street = result['logradouro']
      addr.city = result['localidade']
      addr.state = result['uf']
      addr.neighborhood = result['bairro']
    end
  end
end
