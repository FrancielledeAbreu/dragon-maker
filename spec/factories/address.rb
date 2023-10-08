FactoryBot.define do
  factory :address do
    cep { '81490500' }
    street { 'Test Street' }
    neighborhood { 'Test Neighborhood' }
    city { 'Test City' }
    state { 'TS' }
  end
end
