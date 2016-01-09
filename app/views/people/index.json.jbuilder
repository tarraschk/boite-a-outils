json.array!(@people) do |person|
  json.extract! person, :id, :people_id, :parent_id, :recruiter_id, :email
  json.url person_url(person, format: :json)
end
