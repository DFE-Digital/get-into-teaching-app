RSpec::Matchers.define :include_analytics do |controller, state|
  match do |actual|
    return false unless actual =~ %r{data-controller="#{controller}"}
    return false unless state.all? do |key, value|
      actual =~ %r{data-#{controller}-#{key}="#{value}"}
    end

    true
  end
end
