class GroupProfileImageUploader < ImageUploader # クラスの継承
  # 画像の上限を640x480にする
  process :resize_to_limit => [640, 480]

  # サムネイルを生成する設定(継承先で記入)
  version :thumb80 do
    process :resize_to_fill => [80, 80, gravity = ::Magick::CenterGravity]
  end

  version :thumb20 do
    process :resize_to_fill => [20, 20, gravity = ::Magick::CenterGravity]
  end
end