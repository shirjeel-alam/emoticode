# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  token      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  handle     :string(255)
#

class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :presence => true

  def url
    hostname = case provider
               when 'facebook'
                 'www.facebook.com'
               when 'github'
                 'www.github.com'
               else
                 'www.???.com'
               end   

    nickname = handle || uid

    "http://#{hostname}/#{nickname}"
  end
end
