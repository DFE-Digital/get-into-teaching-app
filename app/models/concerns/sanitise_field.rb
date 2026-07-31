module SanitiseField
  def sanitise_field(field_name)
    value = send(field_name)
    # removes wrapping whitespace and nils if blank
    send("#{field_name}=".to_sym, value.to_s.strip.presence) unless value.nil?
  end
end
