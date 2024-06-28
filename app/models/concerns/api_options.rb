module ApiOptions
  def generate_api_options(api_klass, method_call, omit_ids = [], include_ids = [])
    api = api_klass.new

    items = api.send(method_call)

    items.reject! { |item| omit_ids.include?(item.id) } if omit_ids.present?
    items.select! { |item| include_ids.include?(item.id) } if include_ids.present?

    items.reduce({}) { |options, item| options.update(item.value => item.id) }
  end
end
