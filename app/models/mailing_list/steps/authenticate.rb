module MailingList
  module Steps
    class Authenticate < GITWizard::Steps::Authenticate
      include FunnelTitle

      def title_attribute
        :title
      end

      def skip_title_suffix?
        true
      end
    end
  end
end
