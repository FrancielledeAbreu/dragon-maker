require 'rails_helper'

RSpec.describe Address, type: :model do
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

  it { should have_many(:users) }
  it { should have_many(:contacts) }

  describe '.create_from_cep' do
    it 'creates an address from CEP' do
      address = Address.create_from_cep('81490500')
      expect(address.street).to eq('Test Street')
      expect(address.city).to eq('Test City')
      expect(address.state).to eq('TS')
      expect(address.neighborhood).to eq('Test Neighborhood')
    end
  end
end
