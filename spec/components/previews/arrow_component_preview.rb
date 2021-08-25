class ArrowComponentPreview < ViewComponent::Preview
  def with_straight_horizontal_line_left_to_right
    arrow = ArrowComponent.new(
      width: 200,
      height: 50,
      x1: 0,
      y1: 0.5,
      x2: 1,
      y2: 0.5,
      cx: 0,
      cy: 0.5,
      arrow_size: 0.06,
    )
    render(arrow)
  end

  def with_straight_horizontal_line_right_to_left
    arrow = ArrowComponent.new(
      width: 200,
      height: 50,
      x1: 1,
      y1: 0.5,
      x2: 0,
      y2: 0.5,
      cx: 0.5,
      cy: 0.5,
      arrow_size: 0.12,
    )
    render(arrow)
  end

  def with_straight_vertial_line_top_to_bottom
    arrow = ArrowComponent.new(
      width: 50,
      height: 200,
      x1: 0.5,
      y1: 0,
      x2: 0.5,
      y2: 1,
      cx: 0.5,
      cy: 0.5,
      arrow_size: 0.12,
    )
    render(arrow)
  end

  def with_straight_vertial_line_bottom_to_top
    arrow = ArrowComponent.new(
      width: 50,
      height: 200,
      x1: 0.5,
      y1: 1,
      x2: 0.5,
      y2: 0,
      cx: 0.5,
      cy: 0.5,
      arrow_size: 0.12,
    )
    render(arrow)
  end

  def with_curved_line
    arrow = ArrowComponent.new(
      width: 200,
      height: 200,
      x1: 0,
      y1: 0.5,
      x2: 1,
      y2: 0.5,
      cx: 0.5,
      cy: 0.1,
      arrow_size: 0.1,
    )
    render(arrow)
  end

  def with_no_arrow_head
    arrow = ArrowComponent.new(
      width: 200,
      height: 200,
      x1: 0,
      y1: 0.5,
      x2: 1,
      y2: 0.5,
      cx: 0.5,
      cy: 0.1,
      arrow_size: 0,
    )
    render(arrow)
  end

  def with_large_arrow_head
    arrow = ArrowComponent.new(
      width: 200,
      height: 200,
      x1: 0,
      y1: 0.5,
      x2: 1,
      y2: 0.5,
      cx: 0.5,
      cy: 0.1,
      arrow_size: 0.3,
    )
    render(arrow)
  end
end
