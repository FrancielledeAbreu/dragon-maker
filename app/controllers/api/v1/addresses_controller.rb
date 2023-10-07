module Api
  module V1
    class AddressesController < ApplicationController
      def search
        results = ViaCepService.by_city_and_address(params[:uf], params[:city], params[:street])

        if results.empty?
          render json: { error: 'No addresses found' }, status: :not_found
        else
          addresses = results&.map do |result|
            Address.find_or_create_by(cep: result['cep']) do |address|
              address.street = result['logradouro']
              address.city = result['localidade']
              address.state = result['uf']
              address.neighborhood = result['bairro']
            end
          end

          render json: addresses, status: :ok
        end
      end

      def search_by_cep
        result = ViaCepService.fetch_address(params[:cep])

        if result && result['erro'] != true
          address = Address.find_or_create_by(cep: result['cep']) do |addr|
            addr.street = result['logradouro']
            addr.city = result['localidade']
            addr.state = result['uf']
            addr.neighborhood = result['bairro']
          end

          render json: address, status: :ok
        else
          render json: { error: 'Address not found' }, status: :not_found
        end
      end
    end
  end
end
