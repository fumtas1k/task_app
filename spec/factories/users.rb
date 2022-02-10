FactoryBot.define do
  factory :user do
    name { "夏目 漱石" }
    sequence(:email, "example001@diver.com")
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end
end
