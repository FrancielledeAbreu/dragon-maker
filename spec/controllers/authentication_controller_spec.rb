require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
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
  end
  let(:user) { create(:user, password: 'password123') }

  describe 'POST #register' do
    context 'with valid attributes' do
      let(:valid_attributes) do
        {
          name: 'Test Name',
          email: 'test_name@example.com',
          password: 'password123',
          cep: '81490500',
          cpf: '050.544.730-41',
          phone: '41991295554',
          street_number: '15'
        }
      end

      it 'creates a new user and returns a token' do
        post :register, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        {
          name: 'Test',
          email: '',
          password: 'password123',
          cep: '81490500',
          cpf: '050.544.730-41',
          phone: '41991295554',
          street_number: '15'
        }
      end

      it 'returns an error' do
        post :register, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

  describe 'POST #login' do
    context 'with valid credentials' do
      let(:valid_credentials) do
        {
          email: user.email,
          password: 'password123'
        }
      end

      it 'returns a token' do
        post :login, params: valid_credentials
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      let(:invalid_credentials) do
        {
          email: user.email,
          password: 'wrongpassword'
        }
      end

      it 'returns an error' do
        post :login, params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
