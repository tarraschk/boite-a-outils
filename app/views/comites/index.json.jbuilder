json.array!(@comites) do |comite|
  json.extract! comite, :id, :number, :typecomite, :slug, :title, :desc1, :desc2, :coordinates, :active
  json.url comite_url(comite, format: :json)
end
