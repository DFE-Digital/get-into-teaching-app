module NavigationHelper
  def navigation_resources
    Pages::Navigation.root_pages
  end
end
