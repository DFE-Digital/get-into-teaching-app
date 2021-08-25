# frozen_string_literal: true

class ArrowComponent < ViewComponent::Base
  require "geometry/bezier"

  # Creates an arrow along a bezier path within the given bounds.
  # All points are relative to the bounds, so with a canvas of 500x500
  # and point (x: 0.5, y: 1) the point would be at (x: 250, y: 500). The
  # arrow head is always relative to the end point (x2, y2).
  #
  # width: width of the canvas
  # height: height of the canvas
  # x1, y1: start point of the line
  # x2, y2: end point of the line
  # cx, cy: control point of the line (determines curvature)
  # arrow_size: between 0 (no arrow) and 1 (arrow head lines equal to arrow length)
  def initialize(width:, height:, x1:, y1:, x2:, y2:, cx:, cy:, arrow_size: 0.1)
    @svg = Victor::SVG.new(width: width, height: height, class: :arrow)
    @from = Geometry::Point[x1 * width, y1 * height]
    @to = Geometry::Point[x2 * width, y2 * height]
    @control = Geometry::Point[cx * width, cy * height]
    @arrow_size = arrow_size
  end

  def call
    # @svg.build calls instance_eval so in order to get
    # the instance variables into the scope we have to
    # re-declare them as local variables here.
    from = @from
    to = @to
    control = @control

    arrow_head_base_line = calculate_arrow_head_base_line

    @svg.build do
      # Draw the bezier path as the arrow line.
      path d: ["M", from.x, from.y, "Q", control.x, control.y, to.x, to.y], class: :line

      # Draw two lines from the end of the arrow back to the arrow head base line points.
      path d: [
        "M",
        arrow_head_base_line.first.x,
        arrow_head_base_line.first.y,
        "L",
        to.x,
        to.y,
        arrow_head_base_line.last.x,
        arrow_head_base_line.last.y,
      ]
    end

    @svg.render.html_safe
  end

  # We take a point along the bezier path (determined by @arrow_size) and
  # calculate a perpendicular line. For example, if @arrow_size is 0.1 it will
  # intersect at the point that is 90% along the bezier path, with a line
  # length that is 10% of the path length:
  #
  # ---------|-
  #
  # If @arrow_size is 0.5 we would get a line similar to:
  #
  #      |
  # -----|-----
  #      |
  def calculate_arrow_head_base_line
    # Construct a bezier path (used to determine arrow orientation).
    bezier_path = Geometry::Bezier.new([@from.x, @from.y], [@control.x, @control.y], [@to.x, @to.y])
    intersection_point = bezier_path[1 - @arrow_size]

    line = Geometry::Line[intersection_point, @to]
    perpendicular_intersecting_line(line)
  end

  # Creates a line perpendicular to the from/to line with its
  # midpoint intersecting at the start of the line. The line length will be
  # equal to the from/to path length. For example:
  #
  # |-
  #
  # |
  # |-----
  # |
  #
  # |
  # |
  # |
  # |----------
  # |
  # |
  # |
  def perpendicular_intersecting_line(line)
    # Break out line coordinates.
    x1 = line.first.x
    y1 = line.first.y
    x2 = line.last.x
    y2 = line.last.y

    # Find the midpoint of the input line.
    mx = (x1 + x2) / 2
    my = (y1 + y2) / 2

    # Center the line on the origin of the input line.
    x1 -= mx
    y1 -= my
    x2 -= mx
    y2 -= my

    # Rotate the line 90 degrees.
    xtemp = x1
    ytemp = y1
    x1 = -ytemp
    y1 = xtemp

    xtemp = x2
    ytemp = y2
    x2 = -ytemp
    y2 = xtemp

    # Move the center point back to where it was.
    x1 += mx
    y1 += my
    x2 += mx
    y2 += my

    Geometry::Line[[x1, y1], [x2, y2]]
  end
end
