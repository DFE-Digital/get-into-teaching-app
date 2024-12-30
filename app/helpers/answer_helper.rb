module AnswerHelper
  include TextFormattingHelper

  def format_answer(answer)
    case answer
    when Date
      answer = answer.to_formatted_s(:govuk_date)
    when Time
      answer
      # time_slot = find_callback_time_slot(answer)
      # answer = time_slot[0] || answer.to_formatted_s(:govuk_time_with_period) # if any issues with matching process it will default to the formatted start time e.g. 10:30am
    end

    safe_format(answer.to_s, wrapper_tag: "span")
  end

  # def find_callback_time_slot(selected_time)
  #   options = callback_options(Callbacks::Steps::Callback.callback_booking_quotas)

  #   options.each_value do |time_slots|
  #     time_slots.each do |time_slot|
  #       return time_slot if time_slot[1] == selected_time
  #     end
  #   end
  #   selected_time
  # end

  def link_to_change_answer(step, question)
    link_to(teacher_training_adviser_step_path(step.key)) do
      safe_html_format("Change <span class='visually-hidden'> #{t("answers.#{step.key}.#{question}.change")}</span>")
    end
  end
end
