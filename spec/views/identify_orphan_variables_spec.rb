require "rails_helper"
include I18n::Backend::Flatten

VARIABLE_REGEX = /<%=\s*(v|value)\s*:(?<content>[a-zA-Z-_0-9]+?)\s*%> |
                  \$(?<content>[a-zA-Z-_0-9]+?)\$ |
                  %\{(?<content>[a-zA-Z-_0-9]+?)\} |
                  \#\{\s*v\s*:(?<content>[a-zA-Z-_0-9]+>?)\}
                  /x

# Matches <%= v :thing %> or <%= value :thing %>
# Matches $thing$
# Matches %{thing}
# Matches #{v :thing}

YAML_FILES = Dir.glob("config/values/*.yml")
CONTENT_FILES = [
  PageLister.all_md_files,
  PageLister.all_erb_files,
  PageLister.all_locale_files,
  PageLister.all_ruby_files,
].flatten

yaml_files_and_values = YAML_FILES.to_h do |file|
  yaml = YAML.load(File.read(file))
  flattened_yaml = flatten_translations(nil, yaml, nil, false).transform_keys { |key| key.to_s.gsub(".", "_") }

  [file, flattened_yaml.keys]
end

content_files_and_values = CONTENT_FILES.index_with do |file|
  File.read(file).scan(VARIABLE_REGEX).map(&:compact).map(&:first)
end

component_files_and_keys = PageLister.all_md_files.index_with do |file|
  content = File.open(file).read
  front_matter = FrontMatterParser::Parser.new(:md).call(content).front_matter

  TemplateHandlers::Markdown::COMPONENT_TYPES.map { |type| front_matter.dig(type) }.compact.map(&:keys).flatten
end


#yaml_variable_values = yaml_files_and_values.values.flatten
#content_variable_values = content_files_and_values.values.flatten
#component_variable_values = component_files_and_keys.values.flatten


# orphan_variables = yaml_variable_values - content_variable_values

orphan_frontend_variables = content_files_and_values.transform_values do |values|
  values.reject { |value| ((yaml_files_and_values.values + component_files_and_keys.values).flatten).include?(value) }
end.compact_blank

# orphan_variables = content_variable_values - yaml_variable_values - component_variable_values
orphan_yaml_variables = yaml_files_and_values.transform_values do |values|
  values.reject { |value| content_files_and_values.values.flatten.include?(value) }
end.compact_blank


describe "Orphan variables checker" do
  it "does not find variables in the config/values/*.yml files that are not included in the content" do
    expect(orphan_yaml_variables).to be_empty
  end

  it "does not find variables in the front end that do not have a corresponding back end variable" do
    expect(orphan_frontend_variables).to be_empty
  end

  orphan_frontend_variables.each do |file, orphan|
    it "is not an orphan value" do
      fail "#{file} contains the key(s) '#{orphan}' which is not referenced in any front matter component or /config/values/*.yml file. Consider removing this if it is no longer used."
    end
  end

  orphan_yaml_variables.each do |file, orphan|
    it "is not an orphan value" do
      fail "#{file} contains the key(s) '#{orphan}' which is not referenced in any markdown, erb, locale or ruby file. Consider removing this if it is no longer used."
    end
  end
end
