# == Schema Information
#
# Table name: links
#
#  id        :integer          not null, primary key
#  source_id :integer          not null
#  tag_id    :integer          not null
#  weight    :float(24)        not null
#

class Link < ActiveRecord::Base
  belongs_to :tag, :counter_cache => :sources_count
  belongs_to :source
end


