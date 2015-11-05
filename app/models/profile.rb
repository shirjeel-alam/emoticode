# == Schema Information
#
# Table name: profiles
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  aboutme           :text(16777215)
#  website           :string(255)
#  gplus             :string(255)
#  avatar            :integer          default(0), not null
#  weekly_newsletter :boolean          default(FALSE)
#  follow_mail       :boolean          default(TRUE)
#

class Profile < ActiveRecord::Base
  include Rateable

  belongs_to :user
  has_many   :comments, -> { where :commentable_type => Comment::COMMENTABLE_TYPES[:profile] }, :foreign_key => :commentable_id

  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  validates_format_of :gplus,   :with => URI::regexp(%w(http https)), :allow_blank => true

  def path
    "/profile/#{user.username}"
  end

  def url
    "http://www.emoticode.net#{path}"
  end

  def commentable_type
    Comment::COMMENTABLE_TYPES[:profile]
  end
end

