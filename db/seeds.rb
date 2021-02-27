# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# #メインのサンプルユーザー
# User.create!(name: "Example User", email: "sample@example.com",password: "foobar")

User.create!(name:  "admin", email: "sample@example.com", password:  "foobar", admin: true, confirmed_at: Time.now)

#追加のユーザーをまとめて生成する
10.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@example.com"
  password = "foobar"
  User.create!(name:  name,
  email: email,
  password: password,
  confirmed_at: Time.now)
end

Teacher.create!(name: "森 直樹", user_id: 1)
Teacher.create!(name: "藤岡 真由美", user_id: 2)

users = User.order(:created_at).take(5)
10.times do |n|
  subject_name = Faker::Science.element
  next_name = "#{n+1}"
  name = subject_name + next_name
  users.each { |user| user.lectures.create!(name: user.id.to_s + name, teacher_id: 1)}
end

5.times do |n|
  content = Faker::Lorem.sentence(word_count: 10)
  lecture_id = 50 - n
  users.each{ |user| user.reviews.create!(content: content, lecture_id: lecture_id, score: 3) }
end

# adminユーザーへの参考になるとリンク
Helpful.create(user_id: 2, review_id: 1)
Notification.create(visitor_id: 2, visited_id: 1, review_id: 1, action: "helpful")

News.create(title: "<お知らせ>ベータ版につきまして", message: "ベータ版を触っていただきありがとうございます。
  触っていただいて不便だと思ったことや、ほしいと思う機能がありましたら[Contact](Googleformに飛びます)に記入していただきたいです。皆様の声をもとによりよいサービスにしていきます。")