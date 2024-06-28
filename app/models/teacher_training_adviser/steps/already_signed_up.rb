module TeacherTrainingAdviser::Steps
  class AlreadySignedUp < GITWizard::Step
    def skipped?
      can_subscribe = @store["can_subscribe_to_teacher_training_adviser"]
      can_subscribe.nil? || can_subscribe
    end

    def can_proceed?
      false
    end
  end
end
