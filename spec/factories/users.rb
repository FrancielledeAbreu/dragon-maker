FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'test@email.com' }
    password { 'password' }
    cpf { '19610579051' }
    phone { '123-456-7890' }
    street_number { '1234' }
    association :address
    cep { address.cep }
  end
end
