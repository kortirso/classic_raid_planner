Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUSGNAG_KEY', '')
end
