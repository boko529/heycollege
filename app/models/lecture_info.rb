class LectureInfo < ApplicationRecord
  enum faculty: { Gensisu: 1, Kougaku: 2, Seikan: 3, Tiiki: 4 }, _prefix: :true 
  enum department: { denden: 0, bukka: 1, kikai: 2, juui: 3, ousei: 4, ryokuti: 5, rigaku: 6, kango: 7, rihabiri: 8, kyouhuku: 9, tijou: 10,kanshisu: 11,maneji: 12, }, _prefix: :true 
  enum major: { joukou: 0, densisu: 1, denbutu: 2, ouka: 3, kakou: 4, material: 5, koukuu: 6, kaiyou: 7, kikaikou: 8, seimei: 9, shokubutu: 10, suuri: 11, buturi: 12, bunshi: 13, seibutu: 14, rigakuryou: 15,sagyouryou: 16, eiyouryou: 17, kankyou: 18,shakyou: 19,ninkan: 20}, _prefix: :true 
  enum day_of_week: { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6, out: 7 }, _prefix: :true # outは時間割外 
  enum semester: { fir_seme: 0, sec_seme: 1, fir_session: 2, sec_session: 3, total_seme: 4}, _prefix: :true # sessionは短期集中、total_semeは通年 
  enum period: { first: 1, second: 2, third: 3, fourth: 4, fifth: 5, sixth: 6}, _prefix: :true 
  belongs_to :lecture
  validates :day_of_week, presence: true
  validates :semester, presence: true
  # validates :period, presence: true
end
