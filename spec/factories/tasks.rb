FactoryBot.define do
  factory :task do
    name { "test_title" }
    description { "test_content" }
    expired_at { 3.days.ago }
  end
end