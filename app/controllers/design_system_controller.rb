class DesignSystemController < ApplicationController
  def index
  end
  
  def components_index
    files = Dir[Rails.root.join("lib/design_system/**/README.html.md")]
    @components = files.map { |file| file.split("/").last(2).first }
  end

  def components_show
    component = params[:id]
    readme = Dir[Rails.root.join("lib/design_system/**/#{component}/README.html.md")].first
    render file: readme.chomp('.html.md')
  end
end
