module NormalisePostcode
  def normalise_postcode(field_name)
    value = send(field_name)

    send("#{field_name}=".to_sym, value.to_s.strip.upcase.presence) unless value.nil?
  end
end
