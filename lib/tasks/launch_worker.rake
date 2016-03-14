task launch_worker: :environment do
  NationBuilderSyncLaunchWorker.perform_async
end