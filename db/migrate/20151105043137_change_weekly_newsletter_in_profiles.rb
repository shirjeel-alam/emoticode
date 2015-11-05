class ChangeWeeklyNewsletterInProfiles < ActiveRecord::Migration
  def change
    change_column :profiles, :weekly_newsletter, :boolean, default: false
  end
end
