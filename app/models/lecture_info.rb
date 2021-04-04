class LectureInfo < ApplicationRecord
  enum faculty: { Gensisu: 1, Kougaku: 2, Seikan: 3, Tiiki: 4 }, _prefix: :true 
  enum department: { denden: 0, bukka: 1, kikai: 2, juuui: 3, ousei: 4, ryokuti: 5, rigaku: 6, kanngo: 7, rihabiri: 8, kyouhuku: 9, tijou: 10,kanshisu: 11,maneji: 12, }, _prefix: :true 
  enum major: { joukou: 0, dennsisu: 1, denbutu: 2, ouka: 3, kakou: 4, koukuu: 5, kaiyou: 6, kikaikou: 7, seimei: 8, shokubutu: 9, suuri: 10, buturi: 11, bunshi: 12, seibutu: 13, rigakuryou: 14,sagyouryou: 15, eiyouryou: 16, kankyou: 17,shokyou: 18,ninkan: 19,maneji: 20,keizai: 21}, _prefix: :true 
  enum day_of_week: { sun: 0, mon: 1, teu: 2, wed: 3, thu: 4, fri: 5, stu: 6}, _prefix: :true 
  enum semester: { first: 0, second: 1}, _prefix: :true 
  enum period: { first: 0, second: 1, third: 2, fourth: 3, fifth: 4, sixth: 5}, _prefix: :true 
  belongs_to :lecture
end
