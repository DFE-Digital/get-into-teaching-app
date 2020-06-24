module Wizard
  class UnknownStep < RuntimeError; end

  class Base
    class_attribute :steps

    class << self
      def indexed_steps
        @indexed_steps ||= steps.index_by(&:key)
      end

      def step(key)
        indexed_steps[key] || raise(UnknownStep)
      end

      def key_index(key)
        steps.index step(key)
      end

      def step_keys
        indexed_steps.keys
      end

      def first_key
        step_keys.first
      end
    end

    delegate :step, :key_index, :indexed_steps, :step_keys, to: :class
    attr_reader :current_key

    def initialize(store, current_key)
      @store = store

      raise(UnknownStep) unless step_keys.include?(current_key)

      @current_key = current_key
    end

    def find(key)
      step(key).new @store
    end

    def find_current_step
      find current_key
    end

    def previous_key(key = current_key)
      earlier_keys(key).reverse.find do |k|
        !find(k).skipped?
      end
    end

    def next_key(key = current_key)
      later_keys(key).find do |k|
        !find(k).skipped?
      end
    end

    def first_step?
      previous_key.nil?
    end

    def last_step?
      next_key.nil?
    end

    def valid?
      active_steps.all?(&:valid?)
    end

    def complete!
      last_step? && valid?
    end

    def invalid_steps
      active_steps.select(&:invalid?)
    end

    def first_invalid_step
      active_steps.find(&:invalid?)
    end

    def later_keys(key = current_key)
      steps[(key_index(key) + 1)..].to_a.map(&:key)
    end

    def earlier_keys(key = current_key)
      index = key_index(key)
      return [] unless index.positive?

      steps[0..(index - 1)].map(&:key)
    end

  private

    def all_steps
      step_keys.map(&method(:find))
    end

    def active_steps
      all_steps.reject(&:skipped?)
    end
  end
end
