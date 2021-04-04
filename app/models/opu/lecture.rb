class Opu::Lecture < Lecture
  # enum lecture_lang: { none: 0, ja: 1, en: 2, ko: 4, zh: 5, fr: 10, de: 11}, _prefix: :true # es=>スペイン語, ko=>韓国語, zh=>中国語, ms=>マレーシア語＋インドネシア語, th=>タイ語, vi=>ベトナム語, ej=>日本語英語兼用, fr => フランス語, de => ドイツ語
  enum field: { Syozemi: 1, Pankyo: 2, English: 3, Shogai: 4, Gaikokugotokubetu: 5, Kaigaikensyu: 6, Kenkou: 7, Zyouhou: 8, Iryo: 9, Senmon: 10, Tokurei: 11, Sikaku: 12, Rikeikiso: 13}, _prefix: :true
  # Syozemi=>初ゼミ,Pankyo=>一般教養, English=>外国語科目(英語), Shogai=>初習外国語, Gaikokugotokubetu: 外国語特別, Kaigaikensyu: 海外研修, Kenkou: 健康スポーツ・科学科目, Zyouhou: 情報基礎, Iryo: 医療保険, Senmon: 専門科目, Tokurei: 特例, Sikaku: 資格, Rikeikiso: 理系基礎科目
  has_many :lecture_infos, dependent: :destroy # lectureが消えたらlecture_infoも消える。
end
