FactoryBot.define do
  factory :article do
    title { Faker::Name.name }
    body { 'body text' }
  end
end
