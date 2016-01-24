json.array!(@addresses) do |address|
  json.extract! address, :id, :address1, :city, :country_code, :zip, :person_id
  json.url address_url(address, format: :json)
end
