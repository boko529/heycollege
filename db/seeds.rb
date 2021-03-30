# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# #メインのサンプルユーザー
# User.create!(name: "Example User", email: "sample@example.com",password: "foobar")

User.create!(name:  "admin", email: "sample@apu.ac.jp", password:  "foobar", message: "HeyCollege運営です。\n英語勉強しています！！", admin: true, confirmed_at: Time.now, agreement: true)

#追加のユーザーをまとめて生成する
30.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@apu.ac.jp"
  password = "foobar"
  User.create!(name:  name,
  email: email,
  password: password,
  confirmed_at: Time.now,
  agreement: true)
end

# ユーザーごとにポイントテーブルを作成
User.all.each do |user|
  user.initial_point
end

User.all.each do |user|
  user_p = user.create_user_point(current_point: 10, total_point: 10)
  user.user_point_history.create(point_type: 1, amount: 10, user_point_id: user_p.id)
end

Teacher.create!(name_ja: "森 直樹", name_en: "MORI NAOKI", user_id: 1)
Teacher.create!(name_ja: "藤岡 真由美",name_en: "FUJIOKA MAYUMI", user_id: 2)

users = User.order(:created_at).take(5)
10.times do |n|
  subject_name_ja = "英語"
  subject_name_en = "English"
  next_name = "#{n+1}"
  name_ja = subject_name_ja + next_name
  name_en = subject_name_en + next_name
  field = "APS"
  language = "en"
  # lecture_term = "First"
  # day_of_week = "Mon"
  # period = "second"
  users.each { |user| user.lectures.create!(name_ja: user.id.to_s + name_ja, name_en: user.id.to_s + name_en, teacher_id: 1, field: field, lecture_lang: language)}
end

5.times do |n|
  content = Faker::Lorem.sentence(word_count: 10)
  lecture_id = 50 - n
  users.each{ |user| user.reviews.create!(content: content, lecture_id: lecture_id, score: 3) }
end

# adminユーザーへの参考になると通知
Helpful.create(user_id: 2, review_id: 1)
Notification.create(visitor_id: 2, visited_id: 1, review_id: 1, action: "helpful")

# adminユーザーへのフォローと通知
Relationship.create(follower_id: 2, followed_id: 1)
Notification.create(visitor_id: 2, visited_id: 1, action: "follow")

News.create(title: "<お知らせ>ベータ版につきまして", message: "ベータ版を触っていただきありがとうございます。
  触っていただいて不便だと思ったことや、ほしいと思う機能がありましたら[Contact](Googleformに飛びます)に記入していただきたいです。皆様の声をもとによりよいサービスにしていきます。")
group = Group.create(name: "白鷺祭")
users = User.all
UserGroupRelation.create(user_id: 1, group_id: 1, admin: true, confirmation: true)
members = users[3..11]
members.each { |user| user.join(group) }

# 団体ごとにポイントテーブルを作成
Group.all.each do |group|
  group.initial_point
end
