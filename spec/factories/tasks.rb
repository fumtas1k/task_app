FactoryBot.define do
  factory :task do
    name { "test_title" }
    description { "test_content" }
    expired_at { 1.days.after }
    created_at { DateTime.now }
    status { Task.statuses.keys[0] }
  end
end