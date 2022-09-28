require "image_sizes"

unless Rails.env.development? || Rails.env.test?
  ImageSizes.warm_cache
end
