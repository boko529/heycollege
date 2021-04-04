class SlideImageUploader < ImageUploader
  # 画像の上限を640x480にする
  process :resize_to_limit => [825, 150]
end