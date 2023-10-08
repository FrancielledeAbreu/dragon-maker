require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    allow(ViaCepService).to receive(:fetch_address).and_return(
      {
        'cep' => '81490500',
        'logradouro' => 'Test Street',
        'localidade' => 'Test City',
        'uf' => 'TS',
        'bairro' => 'Test Neighborhood'
      }
    )
    @mocked_address = FactoryBot.create(:address)
  end

  describe 'Associations' do
    it { should have_many(:contacts).dependent(:destroy) }
  end

  describe 'Validations' do
    before do
      create(:user)
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:street_number) }
  end

  describe 'CPF Validation' do
    before do
      @mocked_address = create(:address)
    end

    context 'when CPF is valid' do
      subject { build(:user, cpf: '61705636055', address: @mocked_address) }
      it { is_expected.to be_valid }
    end

    context 'when CPF is invalid' do
      subject { build(:user, cpf: '00000000000', address: @mocked_address) }
      it { is_expected.to_not be_valid }
      it { is_expected.to validate_presence_of(:cpf) }
    end
  end
end
