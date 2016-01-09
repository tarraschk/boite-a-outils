class NationBuilderClient
  NATION_SLUG     = ENV['NATION_SLUG']
  NATION_API_KEY  = ENV['NATION_API_KEY']

  def self.new
    NationBuilder::Client.new(NATION_SLUG, NATION_API_KEY, retries: 8)
  end
end