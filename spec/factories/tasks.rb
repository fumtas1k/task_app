FactoryBot.define do
  factory :task do
    name { "test title" }
    description { "test content" }
    expired_at { 1.days.after }
    created_at { DateTime.now }
    status { Task.statuses.keys[0] }
    priority { Task.priorities.keys[0] }
    user
  end
end