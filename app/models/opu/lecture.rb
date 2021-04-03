class Opu::Lecture < Lecture
  enum lecture_lang: { none: 0, ja: 1, en: 2, ko: 4, zh: 5, fr: 10, de: 11}, _prefix: :true # es=>スペイン語, ko=>韓国語, zh=>中国語, ms=>マレーシア語＋インドネシア語, th=>タイ語, vi=>ベトナム語, ej=>日本語英語兼用, fr => フランス語, de => ドイツ語
  enum field: { APS: 1, APM: 2, APSAPM: 3, Liberal: 4, Language: 5}, _prefix: :true
end
