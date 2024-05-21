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

  def self.normalise_key(key)
    key.to_s.gsub(/[^\w]/, "_").to_sym
  end

  def self.get(key)
    data[normalise_key(key)]
  end

  def get(key)
    data[self.class.normalise_key(key)]
  end

private

  def load_values(dir_spec)
    {}.tap do |data|
      Dir[dir_spec].each do |filename|
        data.merge!(flatten_hash(YAML.safe_load_file(filename, symbolize_names: false)))
      end
    end
  end

  def flatten_hash(hash)
    # based on https://stackoverflow.com/questions/23521230/flattening-nested-hash-to-a-single-hash-with-ruby-rails
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_hash(v).map do |h_k, h_v|
          h[self.class.normalise_key("#{k}_#{h_k}")] = h_v
        end
      else
        h[self.class.normalise_key(k)] = v
      end
    end
  end
end
