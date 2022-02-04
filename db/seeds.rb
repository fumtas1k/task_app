n = 100_000

n.times do |i|
  Task.create!(
    name: Faker::Book.title,
    description: Faker::Hacker.say_something_smart,
    expired_at: i.days.after,
    status: Task.statuses.keys[i % 3],
  )
end