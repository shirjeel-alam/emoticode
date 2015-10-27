Rails.application.config.middleware.use OmniAuth::Builder do
  facebook = Rails.application.config.secrets['Facebook']
  github = Rails.application.config.secrets['Github']

  provider :facebook, facebook['app_id'], facebook['app_secret']
  provider :github, github['client_id'], github['client_secret'], scope: 'user:email'
end
