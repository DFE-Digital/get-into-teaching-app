BetterHtml.config = BetterHtml::Config.new(YAML.safe_load(File.read(Rails.root.join(".better-html.yml"))))
