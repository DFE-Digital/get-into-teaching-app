module Wizard
  class Store
    class InvalidBackingStore < RuntimeError; end

    delegate :keys, :to_h, :to_hash, to: :combined_data

    def initialize(app_data, crm_data)
      stores = [app_data, crm_data]
      raise InvalidBackingStore unless stores.all? { |s| s.respond_to?(:[]=) }

      @app_data = app_data
      @crm_data = crm_data
    end

    def [](key)
      combined_data[key.to_s]
    end

    def []=(key, value)
      @app_data[key.to_s] = value
    end

    def crm(key)
      @crm_data[key.to_s]
    end

    def fetch(*keys, source: :both)
      array_of_keys = Array.wrap(keys).flatten.map(&:to_s)
      Hash[array_of_keys.zip].merge(store(source).slice(*array_of_keys))
    end

    def persist(attributes)
      @app_data.merge!(attributes.stringify_keys)

      true
    end

    def persist_crm(attributes)
      @crm_data.merge!(attributes.stringify_keys)

      true
    end

    def purge!
      @app_data.clear
      @crm_data.clear
    end

    # purges the CRM data but leaves a subset of app data
    # that might be used on or after the completion page
    def prune!(leave: [])
      @app_data.slice!(*Array.wrap(leave))
      @crm_data.clear
    end

  private

    def store(source)
      case source
      when :crm then @crm_data
      when :app then @app_data
      else combined_data
      end
    end

    def combined_data
      @crm_data.merge(@app_data)
    end
  end
end
