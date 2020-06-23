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

      def step_index(key)
        steps.index step(key)
      end

      def step_keys
        indexed_steps.keys
      end

      def first_step
        step_keys.first
      end
    end

    delegate :step, :step_index, :indexed_steps, :step_keys, to: :class
    attr_reader :current_step

    def initialize(store, current_step)
      @store = store

      raise(UnknownStep) unless step_keys.include?(current_step)

      @current_step = current_step
    end

    def find(key)
      step(key).new @store
    end

    def find_current_step
      find current_step
    end

    def previous_step(key = current_step)
      index = step_index(key)
      index.positive? ? steps[index - 1]&.key : nil
    end

    def next_step(key = current_step)
      steps[step_index(key) + 1]&.key
    end

    def first_step?
      previous_step.nil?
    end

    def last_step?
      next_step.nil?
    end

    def valid?
      all_steps.all?(&:valid?)
    end

    def complete!
      last_step? && valid?
    end

    def invalid_steps
      all_steps.select(&:invalid?)
    end

    def first_invalid_step
      all_steps.find(&:invalid?)
    end

  private

    def all_steps
      step_keys.map(&method(:find))
    end
  end
end
