# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing pages to prevent duplicates on re-seeding
Page.destroy_all

# Create sample pages
Page.create!([
  {
    name: "Connectify Official Page",
    description: "The official page for Connectify, your new social network!",
    category: "Community",
    likes_count: 1500
  },
  {
    name: "Local Coffee Shop",
    description: "Your favorite spot for artisanal coffee and pastries.",
    category: "Business",
    likes_count: 850
  },
  {
    name: "Rails Developers Group",
    description: "A community for Ruby on Rails developers to share knowledge and collaborate.",
    category: "Community",
    likes_count: 2100
  },
  {
    name: "Healthy Living Tips",
    description: "Daily tips and advice for a healthier and happier life.",
    category: "Health & Wellness",
    likes_count: 1200
  },
  {
    name: "Tech Innovations 2025",
    description: "Stay updated with the latest breakthroughs in technology.",
    category: "Technology",
    likes_count: 980
  },
  {
    name: "Global Travel Adventures",
    description: "Explore the world with us! Sharing breathtaking destinations and travel guides.",
    category: "Travel",
    likes_count: 3200
  },
  {
    name: "Art & Design Showcase",
    description: "A platform for artists and designers to showcase their creative works.",
    category: "Arts",
    likes_count: 700
  }
])

puts "Created #{Page.count} pages."