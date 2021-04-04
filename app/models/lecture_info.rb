class LectureInfo < ApplicationRecord
  enum faculty: { Gensisu: 1, Kougaku: 2, Seikan: 3, Tiiki: 4 }, _prefix: :true 
  enum department: { denden: 0, bukka: 1, kikai: 2, juui: 3, ousei: 4, ryokuti: 5, rigaku: 6, kango: 7, rihabiri: 8, kyouhuku: 9, tijou: 10,kanshisu: 11,maneji: 12, }, _prefix: :true 
  enum major: { joukou: 0, densisu: 1, denbutu: 2, ouka: 3, kakou: 4, material: 5, koukuu: 6, kaiyou: 7, kikaikou: 8, seimei: 9, shokubutu: 10, suuri: 11, buturi: 12, bunshi: 13, seibutu: 14, rigakuryou: 15,sagyouryou: 16, eiyouryou: 17, kankyou: 18,shakyou: 19,ninkan: 20}, _prefix: :true 
  enum day_of_week: { sun: 0, mon: 1, teu: 2, wed: 3, thu: 4, fri: 5, stu: 6}, _prefix: :true 
  enum semester: { fir_seme: 0, sec_seme: 1}, _prefix: :true 
  enum period: { first: 0, second: 1, third: 2, fourth: 3, fifth: 4, sixth: 5}, _prefix: :true 
  belongs_to :lecture
end
