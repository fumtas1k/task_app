FactoryBot.define do
  factory :user do
    name { "夏目 漱石" }
    email { "example@diver.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
