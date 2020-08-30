FactoryBot.define do
  factory :user do
    name { "Juan" }
    uuid { SecureRandom.uuid }
  end
end
