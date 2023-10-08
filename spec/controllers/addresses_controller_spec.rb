require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  before do
    allow(ViaCepService).to receive(:fetch_address).with('81490500').and_return(
      {
        'cep' => '81490500',
        'logradouro' => 'Test Street',
        'localidade' => 'Test City',
        'uf' => 'TS',
        'bairro' => 'Test Neighborhood'
      }
    )

    allow(ViaCepService)
      .to receive(:by_city_and_address)
      .and_return(
        [
          {
            'cep' => '81490500',
            'logradouro' => 'Test Street',
            'localidade' => 'Test City',
            'uf' => 'TS',
            'bairro' => 'Test Neighborhood'
          }
        ]
      )
  end

  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, 'your_secret', 'HS256') }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #search_by_cep' do
    context 'when address is found' do
      it 'returns address for the given cep' do
        get :search_by_cep, params: { cep: '81490500' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['cep']).to eq('81490500')
      end
    end

    context 'when address is not found' do
      before do
        allow(ViaCepService).to receive(:fetch_address).and_return(nil)
      end

      it 'returns an error' do
        get :search_by_cep, params: { cep: '00000000' }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Address not found')
      end
    end
  end

  describe 'GET #search' do
    context 'when results are found' do
      before do
        request.headers['Authorization'] = nil
      end

      it 'returns addresses based on search criteria' do
        get :search, params: { uf: 'TS', city: 'Test City', street: 'Test Street' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).first['cep']).to eq('81490500')
      end
    end

    context 'when no results are found' do
      before do
        allow(ViaCepService).to receive(:by_city_and_address).and_return([])
      end

      it 'returns an error' do
        get :search, params: { uf: 'TS', city: 'Test City', street: 'Unknown Street' }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('No addresses found')
      end
    end
  end
end
