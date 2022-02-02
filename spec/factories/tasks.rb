FactoryBot.define do
  factory :task do
    name { "test_title" }
    description { "test_content" }
    expired_at { 1.days.after }
    created_at { DateTime.now }
  end
end