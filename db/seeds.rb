user_n = 10
task_n = 3
label_n = 10

User.create!(
  name: "adminuser",
  email: "adminuser@diver.com",
  password: "password",
  admin: true,
)

labels = (0..(label_n-1)).map{|i|
  Label.create!(name: "タスク#{format("%02d", i)}").id
}

user_n.times do |i|
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.free_email,
    password: "password",
  )
  task_n.times do |j|
    user.tasks.create!(
      name: Faker::Book.title,
      description: Faker::Hacker.say_something_smart,
      expired_at: (rand(1..user_n)).days.after,
      status: Task.statuses.keys[rand(0..2)],
      priority: Task.priorities.keys[rand(0..2)],
      label_ids: labels.sample(i * j % 4 + 1)
    )
  end
end