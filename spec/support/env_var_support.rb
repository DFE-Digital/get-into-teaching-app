shared_context "with stubbed env vars" do |envvars|
  before do
    allow(ENV).to receive(:[]).and_call_original

    envvars.each do |key, value|
      allow(ENV).to receive(:[]).with(key).and_return(value)
    end
  end
end
