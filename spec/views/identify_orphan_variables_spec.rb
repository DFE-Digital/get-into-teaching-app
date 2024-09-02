require "rails_helper"
include I18n::Backend::Flatten

VARIABLE_REGEX = /<%=\s*v\s*:(?<content>.+?)\s*%> |
                  \$(?<content>.+?)\$ |
                  %\{(?<content>.+?)\} |
                  \#\{\s*v\s*:(?<content>.+>?)\}
                  /x

                  # Matches <%= v :thing %>
                  # Matches $thing$
                  # Matches %{thing}
                  # Matches #{v :thing}

YAML_FILES = Dir.glob("config/values/*.yml")
CONTENT_FILES = [
  PageLister.all_md_files,
  PageLister.all_erb_files,
  PageLister.all_locale_files,
  PageLister.all_ruby_files
].flatten

yaml_files_and_values = YAML_FILES.to_h do |file|
  yaml = YAML.load(File.read(file))
  flattened_yaml = flatten_translations(nil, yaml, nil, false).transform_keys {|key| key.to_s.gsub(".", "_") }

  [file, flattened_yaml.keys]
end

content_files_and_values = CONTENT_FILES.to_h do |file|
  [file, File.read(file).scan(VARIABLE_REGEX).map(&:compact).map(&:first)]
end

yaml_variable_values = yaml_files_and_values.values.flatten
content_variable_values = content_files_and_values.values.flatten
orphan_variables = yaml_variable_values.difference(content_variable_values)

describe "Orphan variables checker" do
  it "does not find any orphan variables" do
    expect(orphan_variables).to be_empty
  end

  orphan_variables.each do |orphan_variable|
    it "is not an orphan value" do
      file = yaml_files_and_values.find {|k, v| v.include?(orphan_variable) }.first

      fail "#{file} contains the key '#{orphan_variable}' which is not included in any content file. Consider removing this if it is no longer used."
    end
  end
end
