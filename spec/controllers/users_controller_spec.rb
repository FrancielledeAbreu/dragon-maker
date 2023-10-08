require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
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
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, 'your_secret', 'HS256') }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #show' do
    it 'returns user details' do
      get :show
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let(:new_name) { 'Updated Name' }
      let(:valid_attributes) { { user: { name: new_name } } }

      it 'updates user details' do
        put :update, params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq(new_name)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { user: { email: '' } } }

      it 'returns an error' do
        put :update, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with correct password' do
      it 'deletes the user' do
        delete :destroy, params: { password: user.password }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('User and all associated data deleted successfully')
      end
    end

    context 'with incorrect password' do
      it 'returns an error' do
        delete :destroy, params: { password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
