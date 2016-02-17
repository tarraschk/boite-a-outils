task launch_worker: :environment do
  NationBuilderSyncWorker.perform_async
end