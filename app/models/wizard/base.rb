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
      earlier_steps(key).reverse.find do |step|
        !find(step).skipped?
      end
    end

    def next_step(key = current_step)
      later_steps(key).find do |step|
        !find(step).skipped?
      end
    end

    def first_step?
      previous_step.nil?
    end

    def last_step?
      next_step.nil?
    end

    def valid?
      active_step_instances.all?(&:valid?)
    end

    def complete!
      last_step? && valid?
    end

    def invalid_steps
      active_step_instances.select(&:invalid?)
    end

    def first_invalid_step
      active_step_instances.find(&:invalid?)
    end

    def later_steps(key = current_step)
      steps[(step_index(key) + 1)..].to_a.map(&:key)
    end

    def earlier_steps(key = current_step)
      index = step_index(key)
      return [] unless index.positive?

      steps[0..(index - 1)].map(&:key)
    end

  private

    def all_step_instances
      step_keys.map(&method(:find))
    end

    def active_step_instances
      all_step_instances.reject(&:skipped?)
    end
  end
end
