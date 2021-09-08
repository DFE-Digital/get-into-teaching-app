require "rails_helper"

describe ApiModelConvertible do
  let(:testing_model) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ApiModelConvertible

      attribute :type_id
      attribute :status_id
      attribute :readable_id
    end
  end

  let(:api_model) do
    model = GetIntoTeachingApiClient::TeachingEvent.new
    model.type_id = "test"
    model.status_id = "test"
    model
  end

  let(:tester) { testing_model.new }

  describe "#convert_attributes_from_api_model" do
    let(:converted_hash) { testing_model.convert_attributes_from_api_model(api_model) }

    it "returns a hash of snake case attributes" do
      expect(converted_hash).to have_key("type_id")
    end

    it "only returns attributes which are present on the model that includes ApiModelConvertable" do
      expect(converted_hash).not_to have_key("readable_id")
    end
  end

  describe "#convert_attributes_for_api_model" do
    it "returns a hash of camel case attributes" do
      tester.type_id = "test"
      hash = tester.convert_attributes_for_api_model
      expect(hash).to have_key("typeId")
    end

    it "only returns attributes that are present" do
      tester.status_id = ""
      hash = tester.convert_attributes_for_api_model
      expect(hash).not_to have_key("statusId")
    end
  end
end
