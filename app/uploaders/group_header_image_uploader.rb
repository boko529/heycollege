class GroupHeaderImageUploader < ImageUploader # クラスの継承
  # 画像の上限を640x480にする
  process :resize_to_limit => [600, 200]
end