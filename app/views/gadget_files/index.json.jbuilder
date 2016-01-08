json.array!(@gadget_files) do |gadget_file|
  json.extract! gadget_file, :id, :url, :html
  json.url gadget_file_url(gadget_file, format: :json)
end
