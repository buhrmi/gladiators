namespace :background do
  desc "Periodically scans our blockchains for new blocks"
  task scanner: :environment do
    while true
      Networks::Bitcoin.scan!
      sleep 60
    end
  end
end
