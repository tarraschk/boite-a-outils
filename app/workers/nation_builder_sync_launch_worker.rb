class NationBuilderSyncLaunchWorker
  include Sidekiq::Worker

  def perform
    last_synchronization = Synchronization.find_or_initialize_by(event: 'people')
    last_updated_at = last_synchronization.updated_at
    last_synchronization.updated_at = Time.now

    client = NationBuilderClient.new
    params = last_updated_at ? [:search, updated_since: last_updated_at.strftime "%Y-%m-%dT%H:%M:%S%z", limit: 100] : [:index, limit: 100]
    puts params
    paginator = NationBuilder::Paginator.new(client, client.call(:people, *params))
    while paginator.next?
      paginator.body['results'].each do |result|
        NationBuilderSyncWorker.perform_async(result['id'])
      end
      begin
        paginator = paginator.next
      rescue => e
        Rails.logger.error e
        Mailer.new.send_error "NationBuilderSyncLaunchWorker\n" + e.message  + "\n" + e.backtrace.inspect
        retry
      end
    end

    Synchronization.record_timestamps = false
    last_synchronization.save

  rescue => e
    Rails.logger.error e
    Mailer.new.send_error "NationBuilderSyncLaunchWorker\n" + e.message  + "\n" + e.backtrace.inspect
  ensure
    Synchronization.record_timestamps = true
    sleep 600
    NationBuilderSyncLaunchWorker.perform_async
  end
end
