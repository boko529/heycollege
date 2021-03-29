class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # サイズのバリデーション
  def size_range
    0..2.megabytes
  end
  # Choose what kind of storage to use for this uploader:
  
  # storage :file
  # storage :fog

  # 環境に応じて保存先を変更(本番のみaws)
  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 画像の上限を640x480にする(継承先で記入)
  #process :resize_to_limit => [640, 480]

  # 保存形式をJPGにする
  process :convert => 'png'

  # サムネイルを生成する設定(継承先で記入)
  # version :thumb80 do
  #   process :resize_to_fill => [80, 80, gravity = ::Magick::CenterGravity]
  # end

  # version :thumb20 do
  #   process :resize_to_fill => [20, 20, gravity = ::Magick::CenterGravity]
  # end

  # 画像の反転を防ぐ
  def auto
    manipulate! do|image|
      image.auto_orient
    end
  end

  process :auto

  # jpg,jpeg,gif,pngしか受け付けない
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
  def filename
    super.chomp(File.extname(super)) + '.png' if original_filename.present?
  end

  # ファイル名を日付にするとタイミングのせいでサムネイル名がずれる
  #ファイル名はランダムで一意になる
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
