Rails.application.config.middleware.use OmniAuth::Builder do
  provider :viddy, ENV['VIDDY_KEY']
end
