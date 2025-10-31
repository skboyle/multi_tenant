# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "open-uri"

puts "Seeding teams, users, projects, and tasks..."

# ------------------------------
# Team 1: Everybody's Favorite Records
# ------------------------------
team1 = Team.create!(
  name: "Everybody's Favorite Records",
  theme_color: "Green" # green
)
ActsAsTenant.with_tenant(team1) do
# Attach logo
team1_logo_file = URI.open("https://imgur.com/46DXrU9")
team1.logo.attach(io: team1_logo_file, filename: "records_logo.png")

# Users
3.times do |i|
  user = team1.users.create!(
    name: "RecordUser#{i + 1}",
    email: "record#{i + 1}@example.com",
    password: "password"
  )
  # Optional avatar
  # user.avatar.attach(io: URI.open("some_url"), filename: "avatar#{i + 1}.png")
end

# Projects & Tasks
project1 = team1.projects.create!(
  title: "Complete New Album",
  description: "All steps needed to record, approve, and finalize a new album.",
  project_leader: team1.users.first
)
project1.tasks.create!(title: "Record Band", description: "Book studio time and record all tracks.")
project1.tasks.create!(title: "Approve Final Recording", description: "Finalize mixes and master recordings.")
project1.tasks.create!(title: "Finalize Album Artwork", description: "Complete cover art and inserts.")

project2 = team1.projects.create!(
  title: "Manufacturing and Distribution",
  description: "Prepare and distribute physical and digital copies of the album.",
  project_leader: team1.users.second
)
project2.tasks.create!(title: "Print Record", description: "Manufacture physical CDs/vinyls.")
project2.tasks.create!(title: "Get Distribution", description: "Partner with distributors and platforms.")
project2.tasks.create!(title: "Set Price", description: "Decide pricing strategy for all formats.")

project3 = team1.projects.create!(
  title: "Marketing",
  description: "Promote the album through all available channels.",
  project_leader: team1.users.third
)
project3.tasks.create!(title: "Develop marketing material", description: "Create flyers, ads, and digital content.")
project3.tasks.create!(title: "Schedule appearances", description: "Plan interviews, live shows, and events.")
project3.tasks.create!(title: "Social Media campaign", description: "Manage and schedule posts for all platforms.")
end

# ------------------------------
# Team 2: Orange Eye (Independent Film)
# ------------------------------
team2 = Team.create!(
  name: "Orange Eye",
  theme_color: "Orange" # orange
)
ActsAsTenant.with_tenant(team2) do
team2_logo_file = URI.open("https://imgur.com/9br1M39")
team2.logo.attach(io: team2_logo_file, filename: "orange_eye_logo.png")

3.times do |i|
  user = team2.users.create!(
    name: "FilmUser#{i + 1}",
    email: "film#{i + 1}@example.com",
    password: "password"
  )
end

# Projects & Tasks
proj1 = team2.projects.create!(
  title: "Pre-Production",
  description: "Planning, storyboarding, casting, and location scouting.",
  project_leader: team2.users.first
)
proj1.tasks.create!(title: "Write Script", description: "Complete screenplay and revisions.")
proj1.tasks.create!(title: "Casting", description: "Select actors for all roles.")
proj1.tasks.create!(title: "Scout Locations", description: "Identify shooting locations.")

proj2 = team2.projects.create!(
  title: "Production",
  description: "Shooting all scenes according to the script and schedule.",
  project_leader: team2.users.second
)
proj2.tasks.create!(title: "Film Scenes", description: "Shoot all scheduled scenes.")
proj2.tasks.create!(title: "Manage Crew", description: "Ensure smooth operations on set.")
proj2.tasks.create!(title: "Sound Recording", description: "Record all dialogue and ambient sounds.")

proj3 = team2.projects.create!(
  title: "Post-Production",
  description: "Editing, VFX, and preparing for release.",
  project_leader: team2.users.third
)
proj3.tasks.create!(title: "Edit Footage", description: "Assemble scenes into final cut.")
proj3.tasks.create!(title: "Add VFX", description: "Include visual effects as needed.")
proj3.tasks.create!(title: "Color Grading & Sound Mixing", description: "Final polish for visuals and audio.")
end

# ------------------------------
# Team 3: Smooth Mouse Studios (Indie Video Game)
# ------------------------------
team3 = Team.create!(
  name: "Smooth Mouse Studios",
  theme_color: "Blue" # blue
)
ActsAsTenant.with_tenant(team3) do
team3_logo_file = URI.open("https://i.imgur.com/8qDmIim.png")
team3.logo.attach(io: team3_logo_file, filename: "smooth_mouse_logo.png")

3.times do |i|
  user = team3.users.create!(
    name: "GameUser#{i + 1}",
    email: "game#{i + 1}@example.com",
    password: "password"
  )
end

# Projects & Tasks
g_proj1 = team3.projects.create!(
  title: "Design & Concept",
  description: "Create game concept, characters, and mechanics.",
  project_leader: team3.users.first
)
g_proj1.tasks.create!(title: "Create Game Concept", description: "Define core idea and gameplay loop.")
g_proj1.tasks.create!(title: "Design Characters", description: "Draw characters and define abilities.")
g_proj1.tasks.create!(title: "Plan Mechanics", description: "Outline level design and gameplay mechanics.")

g_proj2 = team3.projects.create!(
  title: "Development",
  description: "Code the game and integrate assets.",
  project_leader: team3.users.second
)
g_proj2.tasks.create!(title: "Implement Mechanics", description: "Code core gameplay features.")
g_proj2.tasks.create!(title: "Integrate Art Assets", description: "Add character, environment, and UI assets.")
g_proj2.tasks.create!(title: "Debug & Test", description: "Fix bugs and test functionality.")

g_proj3 = team3.projects.create!(
  title: "Launch Preparation",
  description: "Prepare for release, marketing, and distribution.",
  project_leader: team3.users.third
)
g_proj3.tasks.create!(title: "Optimize Performance", description: "Ensure smooth gameplay on all platforms.")
g_proj3.tasks.create!(title: "Marketing Campaign", description: "Plan trailers, social media, and PR.")
g_proj3.tasks.create!(title: "Release & Distribution", description: "Launch on stores and digital platforms.")
end
puts "Seeding complete!"
