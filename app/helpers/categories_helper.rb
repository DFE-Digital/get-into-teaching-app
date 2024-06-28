module CategoriesHelper
  def ungrouped_categories(path)
    all_categories(path)[nil]
  end

  def grouped_categories(path)
    all_categories(path).reject { |k, _| k.nil? }
  end

private

  def all_categories(path)
    Pages::Navigation.find(path).children.group_by(&:subcategory)
  end
end
