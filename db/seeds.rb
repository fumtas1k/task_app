user_n = 10
task_n = 3

user_n.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.free_email,
    password: "password",
  )
  task_n.times do |i|
    user.tasks.create!(
      name: Faker::Book.title,
      description: Faker::Hacker.say_something_smart,
      expired_at: (rand(1..user_n)).days.after,
      status: Task.statuses.keys[rand(0..2)],
      priority: Task.priorities.keys[rand(0..2)],
    )
  end
end