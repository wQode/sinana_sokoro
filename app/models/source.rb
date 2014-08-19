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
  
  before_save :save_words

  def count_words(words)
    wordcount = {}
    #remove whitespace character
    words.split(/\s/).each do |word| 
    # filter the text
    word.gsub(/\+/, ' ')
      .gsub(/\s+/, ' ')
      .gsub(/^\s+/, '')
      .gsub(/\s+$/, '')
      .downcase
      .gsub(/[^0-9a-z\s-]/, '')
      # remove whitespaces and do word
      if word.strip.size > 0
        unless wordcount.key?(word.strip)
          wordcount[word.strip] = 1 
        else
          wordcount[word.strip] = wordcount[word.strip] + 1
        end
      end
    end
    p wordcount
  end

  def save_words
    self.words = count_words(self.original)
  end 


  # def self.filter(term)
  #   term.gsub(/\+/, ' ')
  #     .gsub(/\s+/, ' ')
  #     .gsub(/^\s+/, '')
  #     .gsub(/\s+$/, '')
  #     .downcase
  #     .gsub(/[^0-9a-z\s-]/, '')
  # end

end
