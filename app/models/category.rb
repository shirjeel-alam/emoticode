# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  has_many :posts

  def self.cached
    Rails.cache.fetch "Category#cached", :expires_in => 24.hours do
      Category.order('name ASC').all
    end
  end
end
