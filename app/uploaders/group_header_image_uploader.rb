class GroupHeaderImageUploader < ImageUploader # クラスの継承
  # 画像を600×200で切り取る
  process :resize_to_fill => [600, 200, gravity = ::Magick::CenterGravity]
end