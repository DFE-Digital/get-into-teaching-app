module AnswerHelper
  include TextFormattingHelper

  def format_answer(answer)
    case answer
    when Date
      answer = answer.to_formatted_s(:govuk_zero_pad)
    when Time
      local_time = answer.in_time_zone
      answer = if local_time.hour.zero? && local_time.min.zero?
                 "Midnight"
               elsif local_time.hour == 12 && local_time.min.zero?
                 "Midday"
               else
                 local_time.to_formatted_s(:govuk_time_with_period)
               end
    end

    safe_format(answer.to_s, wrapper_tag: "span")
  end

  def link_to_change_answer(step, question)
    link_to(teacher_training_adviser_step_path(step.key)) do
      safe_html_format("Change <span class='visually-hidden'> #{t("answers.#{step.key}.#{question}.change")}</span>")
    end
  end
end
