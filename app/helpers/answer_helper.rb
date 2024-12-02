module AnswerHelper
  include TextFormattingHelper

  def format_answer(answer)
    case answer
    when Date
      answer = answer.to_formatted_s(:govuk_date)
    when Time
      formatted_time = answer.in_time_zone.to_formatted_s(:govuk_time_with_period)

      # Convert "12:00pm" to "midday" as per GDS guidance
      answer = if formatted_time == "12:00pm"
                 "midday"
               else
                 formatted_time
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
