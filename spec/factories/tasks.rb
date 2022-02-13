FactoryBot.define do
  factory :task do
    name { "タイトル" }
    description { "詳細" }
    expired_at { 1.days.after }
    created_at { DateTime.now }
    status { Task.statuses.keys[0] }
    priority { Task.priorities.keys[0] }
    user

    trait :task_seq do
      sequence(:name, "タイトル001")
      sequence(:description, "詳細001")
      after(:create) do |task|
        create_list(:label, 2, tasks: [task])
      end
    end
  end
end