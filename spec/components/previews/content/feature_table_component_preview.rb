class Content::FeatureTableComponentPreview < ViewComponent::Preview
  def with_title_and_data
    render(Content::FeatureTableComponent.new(data, "Features"))
  end

  def with_data
    render(Content::FeatureTableComponent.new(data))
  end

private

  def data
    {
      "Feature 1" => "Value 1",
      "Feature 2" => "Value 2",
      "Feature 3" => "Value 3",
    }
  end
end
