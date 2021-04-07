class SlideContent < ApplicationRecord
  belongs_to :university
  validates :slide_image, presence: true
  mount_uploader :slide_image, SlideImageUploader 
end
