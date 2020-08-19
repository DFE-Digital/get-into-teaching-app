module Wizard
  module ApiClientSupport
    def export_camelized_hash
      camelize_hash export_data
    end

  private

    def camelize_hash(hash)
      hash.transform_keys { |k| k.camelize(:lower).to_sym }
    end
  end
end
