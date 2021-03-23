class ActiveSupport::TestCase
  # Not storing uploads in the tests
  CarrierWave::Mount::Mounter.class_eval { def store!; end }
  CarrierWave.root = Rails.root.join('test/fixtures/files')

  def after_teardown
    super
    CarrierWave.clean_cached_files!(0)
  end
end