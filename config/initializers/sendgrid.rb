ActionMailer::Base.register_interceptor(SendGrid::MailInterceptor)

ActionMailer::Base.smtp_settings = {
  :address => 'smtp.sendgrid.net',
  :port => '25',
  :domain => 'emoticode.net',
  :authentication => :plain,
  :user_name => Rails.application.config.secrets['Sendgrid']['username'],
  :password => Rails.application.config.secrets['Sendgrid']['password']
}