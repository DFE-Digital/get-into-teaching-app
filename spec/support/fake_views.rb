shared_context "prepend fake views" do
  before do
    ApplicationController.prepend_view_path Rails.root + "spec/support/views"
  end
end
