# db/seeds.rb

# Clear existing data (optional - useful for resetting)
Post.destroy_all
User.destroy_all

# --- Users ---
puts "Creating users..."

admin = User.create!(
  name: "Admin User",
  email: "admin@test.com",
  password: "password",
  admin: true
)

user1 = User.create!(
  name: "Maria Santos",
  email: "maria@test.com",
  password: "password",
  admin: false
)

user2 = User.create!(
  name: "Tony Ramirez",
  email: "tony@test.com",
  password: "password",
  admin: false
)

puts "Users created!"

# --- Posts ---
puts "Creating posts..."

posts = [
  { title: "Chamorro Red Rice", body: "Chef Juan", img: 1 },
  { title: "Garlic Butter Shrimp", body: "Chef Maria", img: 2 },
  { title: "Beef Tinaktak", body: "Chef Tony", img: 3 },
  { title: "Chicken Kelaguen", body: "Chef Lina", img: 4 },
  { title: "BBQ Short Ribs", body: "Chef Ray", img: 5 },
  { title: "Lumpia", body: "Chef Ann", img: 6 }
]

posts.each do |post_data|
  Post.create!(
    title: post_data[:title],
    body: post_data[:body],
    image: "https://picsum.photos/640/480?random=#{post_data[:img]}",
    user: [admin, user1, user2].sample  # randomly assign an owner
  )
end

puts "Posts created!"
puts "Seeding complete!"