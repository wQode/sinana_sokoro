# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  title      :text
#  original   :text
#  words      :text             default("--- {}\n")
#  exceptions :text             default("--- []\n")
#  url        :string(255)
#  count      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Source < ActiveRecord::Base
  belongs_to :user 
  serialize :words, Hash
  serialize :exceptions, Array
  
end
