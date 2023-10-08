require 'rails_helper'

RSpec.describe Contact, type: :model do
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

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:address) }
  end

  describe 'Validations' do
    subject { build(:contact) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:street_number) }
  end

  describe 'CPF Validation' do
    context 'when CPF is valid' do
      subject do
        build(:contact, cpf: '35997995046')
      end
      it { is_expected.to be_valid }
    end

    context 'when CPF is invalid' do
      subject do
        build(:contact, cpf: '00000000000')
      end
      it { is_expected.to_not be_valid }
      it { is_expected.to validate_presence_of(:cpf) }
    end
  end
end
