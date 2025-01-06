require "rails_helper"

YAML_FILES = Dir.glob("config/values/*.yml")

CONTENT_FILES = [
  PageLister.all_md_files,
  PageLister.all_erb_files,
  PageLister.all_locale_files,
].flatten

VARIABLE_REGEX = /<%=\s*(?:v|value)\s*:(?<content>[a-zA-Z_0-9-]+?)\s*%> |
                  \$(?<content>[a-zA-Z_0-9-]+?)\$ |
                  %\{(?<content>[a-zA-Z_0-9-]+?)\} |
                  \#\{\s*v\s*:(?<content>[a-zA-Z_0-9-]+>?)\}/x

# Matches <%= v :thing %> or <%= value :thing %>
# Matches $thing$
# Matches %{thing}
# Matches #{v :thing}

COMPONENT_TYPES = TemplateHandlers::Markdown::COMPONENT_TYPES + %w[calls_to_action images]

IGNORE_VARIABLES = {
  "config/locales/loaf.yml" => %w[invalid valid]
}.freeze

RSpec.describe "orphan variables checker" do
  include I18n::Backend::Flatten

  let!(:yaml_files_and_values) do
    YAML_FILES.to_h do |file|
      yaml = YAML.load(File.read(file))
      flattened_yaml = flatten_translations(nil, yaml, nil, false).transform_keys { |key| key.to_s.gsub(".", "_") }

      [file, flattened_yaml.keys]
    end
  end

  let!(:content_files_and_values) do
    CONTENT_FILES.index_with do |file|
      File.read(file).scan(VARIABLE_REGEX).map(&:compact).flatten
    end
  end

  let!(:component_files_and_keys) do
    PageLister.all_md_files.index_with do |file|
      content = File.open(file).read
      front_matter = FrontMatterParser::Parser.new(:md).call(content).front_matter

      COMPONENT_TYPES.map { |type| front_matter[type] }.compact.map(&:keys).flatten
    end
  end

  let!(:frontend_files_and_values) { (yaml_files_and_values.values + component_files_and_keys.values).flatten }

  let!(:orphan_frontend_variables) do
    orphan_frontend_variables = content_files_and_values.transform_values { |values|
      values.reject { |value| frontend_files_and_values.include?(value) }
    }.compact_blank

    remove_ignored_variables(orphan_frontend_variables)
  end

  let!(:orphan_yaml_variables) do
    orphan_yaml_variables = yaml_files_and_values.transform_values { |values|
      values.reject { |value| content_files_and_values.values.flatten.include?(value) }
    }.compact_blank

    remove_ignored_variables(orphan_yaml_variables)
  end

  it "does not find any variables in the config/values/*.yml files that are not references in any markdown, erb, or locale file" do
    expect(orphan_yaml_variables).to be_empty, error_message(orphan_yaml_variables)
  end

  it "does not find any variables in the frontend that are not referenced in any front matter component or /config/values/*.yml file" do
    expect(orphan_frontend_variables).to be_empty, error_message(orphan_frontend_variables)
  end

  def error_message(file_variables_hash)
    file_variables_hash.map.with_index { |(file, orphan), index|
      "#{index.next}: #{file} contains orphan key(s) '#{orphan.join(', ')}'"
    }.join("\n")
  end

  def remove_ignored_variables(hash, ignore_hash = IGNORE_VARIABLES)
    ignore_hash.map do |file, orphans|
      next if hash[file].nil?

      hash[file] = hash[file] - orphans
    end

    hash.compact_blank
  end
end
