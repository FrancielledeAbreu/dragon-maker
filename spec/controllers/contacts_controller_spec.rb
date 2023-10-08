require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
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

  let(:address) { create(:address) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: 'other@example.com', cpf: '07274493035') }
  let(:contact) { create(:contact, user:, address:) }
  let(:other_contact) { create(:contact, user: other_user, address:) }
  let(:token) { JWT.encode({ user_id: user.id }, 'your_secret', 'HS256') }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #index' do
    it 'lists the user contacts' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_a(Array)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        contact: {
          name: 'John Doe',
          email: 'john@example.com',
          cpf: '27068464025',
          phone: '123456789',
          address_id: address.id,
          street_number: '15',
          complement: 'Apt 202',
          latitude: '-23.550520',
          longitude: '-46.633308'
        }
      }
    end

    it 'creates a contact for the user' do
      expect do
        post :create, params: valid_attributes
      end.to change(user.contacts, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'GET #show' do
    it 'shows a specific contact of the user' do
      get :show, params: { id: contact.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(contact.id)
    end
  end

  describe 'PUT #update' do
    it 'updates a specific contact of the user' do
      put :update, params: { id: contact.id, contact: { name: 'New Name' } }
      expect(response).to have_http_status(:ok)
      expect(contact.reload.name).to eq('New Name')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a specific contact of the user' do
      delete :destroy, params: { id: contact.id }
      expect(response).to have_http_status(:ok)
      expect(Contact.find_by(id: contact.id)).to be_nil
    end
  end

  describe 'GET #show' do
    context 'when trying to access own contact' do
      it 'shows a specific contact of the user' do
        get :show, params: { id: contact.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(contact.id)
      end
    end

    context 'when trying to access another user contact' do
      it 'denies access' do
        expect do
          get :show, params: { id: other_contact.id }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #search' do
    before { contact }

    it 'searches contacts based on provided criteria' do
      get :search, params: { name: 'Contact' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first['id']).to eq(contact.id)
    end
  end
end
