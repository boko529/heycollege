# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

University.create!(name_ja: "立命館アジア太平洋大学")
University.create!(name_ja: "大阪府立大学")

User.create!(name:  "APUadmin", email: "sample@apu.ac.jp", password:  "foobar", message: "HeyCollege運営です。\n英語勉強しています！！", admin: true, confirmed_at: Time.now, agreement: true, type: Apu::User, faculty: "APS", university_id: 1)
User.create!(name:  "OPUadmin", email: "sample@edu.osakafu-u.ac.jp", password:  "foobar", message: "HeyCollege運営です。\n英語勉強しています！！", admin: true, confirmed_at: Time.now, agreement: true, type: Opu::User, faculty: "Kougaku", university_id: 2)

#追加のユーザーをまとめて生成する
15.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@apu.ac.jp"
  password = "foobar"
  User.create!(name:  name,
  email: email,
  password: password,
  confirmed_at: Time.now,
  agreement: true,
  type: Apu::User,
  faculty: "APS",
  university_id: 1)
end

#追加のユーザーをまとめて生成する
15.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@edu.osakafu-u.ac.jp"
  password = "foobar"
  User.create!(name:  name,
  email: email,
  password: password,
  confirmed_at: Time.now,
  agreement: true,
  type: Opu::User,
  faculty: "Gensisu",
  university_id: 2)
end

# ユーザーごとにポイントテーブルを作成
User.all.each do |user|
  user.initial_point
end

User.all.each do |user|
  user_p = user.create_user_point(current_point: 10, total_point: 10)
  user.user_point_history.create(point_type: 1, amount: 10, user_point_id: user_p.id)
end

Teacher.create!(name_ja: "森 直樹", name_en: "MORI NAOKI", user_id: 1, university_id: 1)
Teacher.create!(name_ja: "藤岡 真由美",name_en: "FUJIOKA MAYUMI", user_id: 1, university_id: 1)
teacher = Teacher.create!(name_ja: "山田 太郎",name_en: "Yamada Taro", user_id: 1, university_id: 1)
Lecture.create!(name_ja: "経済学入門", name_en: "Introduction to economics", teacher_id: teacher.id, field: "Liberal", lecture_lang: "ja", user_id: 1, university_id: 1)

Teacher.create!(name_ja: "本田圭佑", name_en: "HONDA KEISUKE", user_id: 2, university_id: 2)
Teacher.create!(name_ja: "春日俊彰",name_en: "KASUGA TOSHIAKI", user_id: 2, university_id: 2)

users = User.where(university_id: 1).order(:created_at).take(5)
5.times do |n|
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
  users.each { |user| Apu::Lecture.create!(name_ja: user.id.to_s + name_ja, name_en: user.id.to_s + name_en, teacher_id: 1, field: field, lecture_lang: language, user_id: user.id, university_id: user.university_id)}
end

5.times do |n|
  content = Faker::Lorem.sentence(word_count: 10)
  lecture_id = n + 1
  users.each{ |user| user.reviews.create!(content: content, lecture_id: lecture_id, score: 3) }
end

users = User.where(university_id: 2).order(:created_at).take(5)
5.times do |n|
  subject_name_ja = "数学"
  subject_name_en = "Mathematic"
  next_name = "#{n+1}"
  name_ja = subject_name_ja + next_name
  name_en = subject_name_en + next_name
  field = 1
  language = 1
  users.each { |user| Opu::Lecture.create!(name_ja: user.id.to_s + name_ja, name_en: user.id.to_s + name_en, teacher_id: 5, field: field, lecture_lang: language, user_id: user.id, university_id: user.university_id)}
end

lectures = Opu::Lecture.all
lectures.each do |lecture|
  LectureInfo.create!(
    faculty: 1,
    department: 1,
    major: 1,
    day_of_week: 1,
    semester: 1,
    period: 1,
    state: 1,
    lecture_id: lecture.id,
  )
end

5.times do |n|
  content = Faker::Lorem.sentence(word_count: 10)
  lecture_id = n + 26
  users.each{ |user| user.reviews.create!(content: content, lecture_id: lecture_id, score: 3) }
end

# adminユーザーへの参考になると通知
Helpful.create(user_id: 2, review_id: 1)
Notification.create(visitor_id: 2, visited_id: 1, review_id: 1, action: "helpful")

# adminユーザーへのフォローと通知
Relationship.create(follower_id: 2, followed_id: 1)
Notification.create(visitor_id: 2, visited_id: 1, action: "follow")

News.create(title: "<お知らせ>アジア太平洋大学について", message: "ベータ版を触っていただきありがとうございます。
  触っていただいて不便だと思ったことや、ほしいと思う機能がありましたら[Contact](Googleformに飛びます)に記入していただきたいです。皆様の声をもとによりよいサービスにしていきます。", university_id: 1)

News.create(title: "<お知らせ>大阪府立大学について", message: "ベータ版を触っていただきありがとうございます。
  触っていただいて不便だと思ったことや、ほしいと思う機能がありましたら[Contact](Googleformに飛びます)に記入していただきたいです。皆様の声をもとによりよいサービスにしていきます。", university_id: 2)

# サンプルグループを2つ作成
group1 = Group.create(name: "学内新聞", profile: "APU学内で新聞を出版しています", university_id: 1)
group2 = Group.create(name: "テニスサークル", profile: "APU公式テニスサークルです。大学から自転車で10分のグラウンドで毎週月水に活動してます！\n初心者大歓迎です。新歓来てね👍", university_id: 1)
group3 = Group.create(name: "白鷺祭", profile: "毎年11月に中百舌鳥キャンパスで行われる大学祭を実行しています。一緒に思い出を作りましょう！", university_id: 2)
group4 = Group.create(name: "スマッシュ", profile: "大阪府立大学のテニスサークルです。", university_id: 2)

UserGroupRelation.create(user_id: 1, group_id: 1, admin: true, confirmation: true)
UserGroupRelation.create(user_id: 1, group_id: 2, admin: true, confirmation: true)
UserGroupRelation.create(user_id: 2, group_id: 3, admin: true, confirmation: true)
UserGroupRelation.create(user_id: 2, group_id: 4, admin: true, confirmation: true)
User.all.where(university_id: 1).where.not(id: 1).each { |user| user.join(group1) && user.join(group2) }
User.all.where(university_id: 2).where.not(id: 2).each { |user| user.join(group3) && user.join(group4) }

# 団体ごとにポイントテーブルを作成
Group.all.each do |group|
  group.initial_point
end

Zoom.create!(title: "オンライン履修相談会",join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: 1,start_time:Time.now+100, end_time:Time.now+200, count: 1, university_id: 1)
Zoom.create!(title: "アメフト部とアイスホッケー部によるオンライン新歓",join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: 2,start_time:Time.now+100, end_time:Time.now+10000, count: 1, university_id: 2)
Zoom.create!(title: "プログラミングに興味がある人集合！",join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: 1,start_time:Time.now+10000, end_time:Time.now+20000, count: 1, university_id: 1)
Zoom.create!(title: "愛知県出身が語り合う会",join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: 2,start_time:Time.now+30000, end_time:Time.now+40000, count: 1, university_id: 2)
