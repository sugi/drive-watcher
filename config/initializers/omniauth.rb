Rails.configuration.google_client_configured = false

begin
  gsetting = YAML.load_file "#{Rails.root}/config/google-api.yml"
  gsetting["client_id"].blank?  and raise Errno::ENOENT
  gsetting["client_secret"].blank? and raise Errno::ENOENT

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, gsetting["client_id"], gsetting["client_secret"], {
      access_type: 'offline',
      scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/drive.metadata.readonly https://www.googleapis.com/auth/drive.readonly',
      # redirect_uri:'http://localhost:3000/auth/google_oauth2/callback'
    }
    Rails.configuration.google_client_configured = true
  end
rescue Errno::ENOENT
  # ignore
end

Rails.configuration.google_client_configured or
  $stderr.puts "Google API client is not configured!\nSet your client information at #{Rails.root}/config/google-api.yml."
