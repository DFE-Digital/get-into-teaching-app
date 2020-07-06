class NumberOfWordsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    max_words = options.fetch(:less_than)

    if number_of_words(value.to_s) > max_words
      record.errors.add attribute, :use_fewer_words, count: max_words
    end
  end

private

  def number_of_words(string)
    string.scan(/\s/).size + 1
  end
end
