module Sections
  class HeaderComponent < ViewComponent::Base
    renders_many :primary_items, "PrimaryItem"

    class PrimaryItem < ViewComponent::Base
      attr_accessor :node

      def initialize(...)
        @node = Node.new(...)

        super
      end

      def call
        class_name = "active" if first_uri_segment_matches_link?(node.path)

        tag.li(class: class_name) do
          safe_join([nav_link(node), secondary_items].compact)
        end
      end

    private

      def secondary_items
        return nil if node.children.none?

        tag.ul(class: "secondary") do
          safe_join(
            node
              .children
              .map { |child| Node.new(child) }
              .map { |child_node| nav_link(child_node) },
          )
        end
      end

      def nav_link(node)
        link_to_unless_current(node.front_matter.navigation_title, node.path)
      end

      def first_uri_segment_matches_link?(link_path)
        current_uri = request.path
        if (matches = /^\/[^\/]*/.match(current_uri))
          matches[0] == link_path
        end
      end
    end

    # Represents a single navigation item, either primary or secondary
    class Node
      attr_reader :path, :front_matter, :children

      def initialize(path:, front_matter:, children: [])
        @path         = path
        @front_matter = FrontMatterNavigation.new(front_matter)
        @children     = children
      end
    end

    # Retrieve only the data we're interested in from the front matter
    class FrontMatterNavigation
      attr_reader :title, :path

      def initialize(**front_matter)
        @navigation_title = front_matter[:navigation_title]
        @title            = front_matter[:title]
        @path             = front_matter[:path]
      end

      def navigation_title
        @navigation_title || title
      end
    end
  end
end
