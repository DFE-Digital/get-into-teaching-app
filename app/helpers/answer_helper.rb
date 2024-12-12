module AnswerHelper
  include TextFormattingHelper

  # def format_answer(answer)
  #   case answer
  #   when Date
  #     answer = answer.to_formatted_s(:govuk_date)
  #   when Time
  #     answer.in_time_zone.to_formatted_s(:govuk_time_with_period)
  #   end

  #   safe_format(answer.to_s, wrapper_tag: "span")
  # end

  def format_answer(answer)
    case answer
    when Date
      answer = answer.to_formatted_s(:govuk_zero_pad)
    when Time
      answer = if callback_time?(answer) # e.g. 2021-09-01 09:00:00 UTC
                 find_callback_time_slot(answer)
               else
                 answer.in_time_zone.to_formatted_s(:govuk_time_with_period)
               end
    end

    safe_format(answer.to_s, wrapper_tag: "span")
  end

private

  # Retrieves available quotas and checks if the answer matches one of the start_at times from the quotas
  def callback_time?(value)
    quotas = Callbacks::Steps::Callback.callback_booking_quotas # This is a method call to the API to get the available callback times
    quotas.any? { |quota| quota.start_at.to_s == value.to_s || quota.start_at == value } # This is a comparison of the time slot start time with the selected time (as a string or without conversion)
  end

  # Finds the full time slot for the given callback time and retrieves the label i.e. the time slot
  def find_callback_time_slot(selected_time)
    options = callback_options(Callbacks::Steps::Callback.callback_booking_quotas) # This is a method call to the API to get the available callback times and format them via the callback_options method/helper

    options.each_value do |times| # This is a loop to find the label for the selected time. First, it iterates over the values of the options hash
      times.each do |label, time| # Then, it iterates over the time slots for each day to find the label for the selected time
        return label if time.to_s == selected_time.to_s # This is a comparison of the time slot with the selected time
      end
    end

    selected_time # Fallback to original value if no match is found
  end

  def link_to_change_answer(step, question)
    link_to(teacher_training_adviser_step_path(step.key)) do
      safe_html_format("Change <span class='visually-hidden'> #{t("answers.#{step.key}.#{question}.change")}</span>")
    end
  end
end
