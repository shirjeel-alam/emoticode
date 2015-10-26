# == Schema Information
#
# Table name: languages
#
#  id            :integer          not null, primary key
#  title         :string(255)      not null
#  name          :string(255)      not null
#  syntax        :string(255)      not null
#  sources_count :integer          default(0)
#

class Language < ActiveRecord::Base
  has_many :sources
  has_many :tags, :through => :links

  scope :popular, -> { order('sources_count DESC') }

  def most_active_users( limit = 3 )
    Rails.cache.fetch "stats_of_#{limit}_users_for_language_#{id}", :expires_in => 24.hours do 
      User.
        joins(:sources).
        select('users.*, COUNT(sources.id) AS hits').
        where( 'sources.language_id = ?', id ).
        where( 'sources.private = 0' ).
        where( 'users.is_bot = 0' ).
        group('users.id').
        order('COUNT(sources.id) DESC').
        limit( limit ).
        to_a
    end
  end

  def self.cached
    Rails.cache.fetch "Language#cached", :expires_in => 24.hours do
      Language.order('name ASC').all
    end
  end
end
