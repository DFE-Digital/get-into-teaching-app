RSpec.shared_examples "sanitize fields" do |fields|
  fields.each do |field|
    it "sanitizes input on the #{field} field" do
      setter = "#{field}="
      subject.send(setter, "   input  ")
      subject.valid?
      expect(subject.send(field)).to eq("input")
      subject.send(setter, "   ")
      subject.valid?
      expect(subject.send(field)).to be_nil
    end
  end
end
