# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data to prevent duplicates on re-seeding
User.destroy_all
Post.destroy_all
Comment.destroy_all
Like.destroy_all
Friendship.destroy_all
Message.destroy_all

puts "Seeding database for FriendZone..."

# 1. Seed 10 demo users
users = []
10.times do |i|
  users << User.create!(
    name: "User #{i + 1}",
    username: "user#{i + 1}",
    email: "user#{i + 1}@friendzone.com",
    bio: "Hello, I am User #{i + 1}. Connecting with friends on FriendZone!",
    avatar: "https://i.pravatar.cc/150?img=#{i + 1}",
    password: "password",
    password_confirmation: "password"
  )
  puts "Created user: #{users.last.username}"
end

# 2. Seed 20 posts spread among users
posts = []
20.times do |i|
  user = users.sample
  content = "This is post number #{i + 1} from #{user.username}. Just sharing some thoughts!"
  image_url = nil

  # Make some posts image-only, some text-only, some both
  if i % 3 == 0
    image_url = "https://picsum.photos/seed/#{rand(1000)}/600/400"
    content = nil # Image-only post
  elsif i % 3 == 1
    content = "Another day, another post! Feeling good on FriendZone. #{i + 1}"
    image_url = "https://picsum.photos/seed/#{rand(1000)}/600/400" # Both
  else
    # Text-only post
  end

  posts << Post.create!(
    user: user,
    content: content,
    image_url: image_url
  )
  puts "Created post #{i + 1} by #{user.username}"
end

# 3. Seed 30 comments randomly attached to posts
30.times do |i|
  user = users.sample
  post = posts.sample
  Comment.create!(
    user: user,
    post: post,
    content: "Great post, #{post.user.username}! This is comment #{i + 1} from #{user.username}."
  )
  puts "Created comment #{i + 1}"
end

# 4. Seed 50 likes across various posts
50.times do |i|
  user = users.sample
  post = posts.sample
  # Ensure unique like per user per post
  unless Like.exists?(user: user, post: post)
    Like.create!(
      user: user,
      post: post
    )
    puts "Created like #{i + 1}"
  end
end

# 5. Seed 15 friendships with random accepted or pending statuses
15.times do |i|
  user1 = users.sample
  user2 = users.sample
  next if user1 == user2 || Friendship.exists?(user: user1, friend: user2) || Friendship.exists?(user: user2, friend: user1)

  status = ['pending', 'accepted'].sample
  Friendship.create!(
    user: user1,
    friend: user2,
    status: status
  )
  puts "Created friendship between #{user1.username} and #{user2.username} (status: #{status})"

  # If accepted, create inverse friendship
  if status == 'accepted'
    Friendship.create!(
      user: user2,
      friend: user1,
      status: 'accepted'
    )
    puts "Created inverse friendship between #{user2.username} and #{user1.username} (status: accepted)"
  end
end

# 6. Seed 10 messages exchanged between random users
10.times do |i|
  sender = users.sample
  receiver = users.sample
  next if sender == receiver

  Message.create!(
    sender: sender,
    receiver: receiver,
    content: "Hello #{receiver.username}, this is a message from #{sender.username}. Message number #{i + 1}."
  )
  puts "Created message #{i + 1} from #{sender.username} to #{receiver.username}"
end

puts "FriendZone seeding complete!"
puts "Total Users: #{User.count}"
puts "Total Posts: #{Post.count}"
puts "Total Comments: #{Comment.count}"
puts "Total Likes: #{Like.count}"
puts "Total Friendships: #{Friendship.count}"
puts "Total Messages: #{Message.count}"