module Wizard
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
    end

    delegate :steps, :step, :step_index, :indexed_steps, to: :class

    def initialize(store)
      @store = store
    end

    def find(key)
      step(key).new @store
    end

    def previous_step(key)
      index = step_index(key)
      index.positive? ? steps[index - 1]&.key : nil
    end

    def next_step(key)
      steps[step_index(key) + 1]&.key
    end

    class UnknownStep < RuntimeError; end
  end
end
