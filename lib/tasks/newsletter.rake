namespace :newsletter do
  desc "Send weekly newsletter"
  task weekly: :environment do
    users   = User.joins(:profile).where(:profiles => {:weekly_newsletter => 1})
    sources = Source.visible.where( 'created_at >= UNIX_TIMESTAMP() - 604800' )
    users.each do |user|
      NewsletterMailer.weekly(user,sources).deliver
    end
  end
end

