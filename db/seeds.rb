# set user seeds
99.times do |n|
  name = Faker::Name.name
  email = "userNumb#{n}@yuyamail.com"
  password = 'password'
  User.create!(name:,
               email:,
               password:,
               password_confirmation: password)
end

# set follow,unfollow seeds
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
