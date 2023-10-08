FactoryBot.define do
  factory :contact do
    name { 'Contact Name' }
    email { 'email@test.com ' }
    cpf { '77325666020' }
    phone { '123-456-7890' }
    street_number { '1234' }
    association :user
    association :address
  end
end
