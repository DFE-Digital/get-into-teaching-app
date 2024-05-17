class Value
  PATH = "config/values/**/*.yml".freeze
  attr_reader :data

  def self.data
    # the value data will rarely change, so OK to cache in a class variable
    @@data ||= new.data
  end

  def initialize(path = nil)
    @data = load_values(path || Rails.root.join(PATH))
  end

private

  def load_values(dir_spec)
    Hash.new.tap do |data|
      Dir[dir_spec].each do |filename|
        data.merge!(flatten_hash(YAML.safe_load_file(filename, symbolize_names: true)))
      end
    end
  end

  def flatten_hash(hash)
    # based on https://stackoverflow.com/questions/23521230/flattening-nested-hash-to-a-single-hash-with-ruby-rails
    hash.each_with_object(Hash.new) do |(k, v), h|
      if v.is_a? Hash
        flatten_hash(v).map do |h_k, h_v|
          h["#{k}_#{h_k}".to_sym] = h_v
        end
      else
        h[k] = v
      end
    end
  end
end
