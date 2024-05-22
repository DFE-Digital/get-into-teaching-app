class Content::QuoteComponentPreview < ViewComponent::Preview
  def default
    component = Content::QuoteComponent.new(**text)
    render(component)
  end

  def with_inline
    component = Content::QuoteComponent.new(
      **text
        .merge(inline),
    )

    render_with_template(
      template: "content/quote_component_preview/inline",
      locals: { component: component },
    )
  end

  def with_author
    component = Content::QuoteComponent.new(
      **text
        .merge(author),
    )
    render(component)
  end

  def with_name
    component = Content::QuoteComponent.new(
      **text
        .merge(author.slice(:name)),
    )
    render(component)
  end

  def with_job_title
    component = Content::QuoteComponent.new(
      **text
      .merge(author.slice(:job_title)),
    )
    render(component)
  end

  def with_author_and_image
    component = Content::QuoteComponent.new(
      **text
        .merge(author)
        .merge(image),
    )
    render(component)
  end

  def with_author_and_image_and_inline
    component = Content::QuoteComponent.new(
      **text
        .merge(author)
        .merge(image)
        .merge(inline),
    )

    render_with_template(
      template: "content/quote_component_preview/inline",
      locals: { component: component },
    )
  end

private

  def text
    {
      text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "\
      "Praesent a nisl semper, efficitur velit ac, tincidunt arcu. "\
      "Morbi non nisl eu arcu molestie lacinia quis quis libero.",
    }
  end

  def author
    {
      name: "John Doe",
      job_title: "Trainee English teacher",
    }
  end

  def image
    {
      image: "images/content/hero-images/maths.jpg",
    }
  end

  def inline
    {
      inline: "left",
    }
  end
end
