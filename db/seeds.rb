# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n|
  subject_name = Faker::Science.element
  next_name = "#{n+1}入門"
  name = subject_name + next_name
  language_used = n % 3
  lecture_type = n % 5
  lecture_size = n % 4
  group_work = n % 2
  lecture_term = n % 4
  Lecture.create!(name: name, language_used: language_used, lecture_type: lecture_type, lecture_term: lecture_term, lecture_size: lecture_size, group_work: group_work)
end