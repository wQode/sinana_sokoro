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
    # filter the text
    list = words.split(' ').reject do |word|
      self.exceptions.include?(word)
    end
    
    list.each do |word|
      # remove whitespaces and do word
      if word.strip.size > 0
        unless wordcount.key?(word.strip)
          wordcount[word.strip] = 1 
        else
          wordcount[word.strip] = wordcount[word.strip] + 1
        end
     end
   end
   wordcount
  end

  def bucket_words
    output = []
    bucket = 0

    self.words.each_slice(30) do |words|
      output[bucket] = {
        :name => bucket,
        :children => []
      }
      words.each do |pair|
        word = pair[0]
        count = pair[1]
        output[bucket][:children].push({
          :name => word,
          :size => count
        })
      end
      bucket += 1
    end

    output
  end

  def save_words
    self.words = count_words(self.original)
  end 

end
