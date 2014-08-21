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
  before_save :save_exceptions

  def normalized_original(original)
    # filters non-word characters and spaces
    original.gsub(/[^a-zA-Z ]/,'').gsub(/ +/,' ')
  end

  def count_words(original)
    wordcount = {}

    filtered_list(normalized_original(original)).each do |word|
      # remove whitespaces and do word
      if word.strip.size >= 4
        unless wordcount.key?(word.strip)
          wordcount[word.strip] = 1 
        else
          wordcount[word.strip] += 1
        end
      end
    end
    self.filter_word_value(wordcount,self.count)
  end

  def filtered_list(original)
    original.downcase.split(' ').reject do |word|
      self.exceptions.include?(word) 
    end
  end

  def filter_word_value(words, value = 5)
    words.reject {|k,v| v <= value }
  end

  def bucket_words
    output = []
    bucket = 0

    self.words.each_slice(25) do |words|
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

  def save_exceptions
    self.exceptions = self.exceptions.split(/\s*,\s*/) if self.exceptions.kind_of? String
  end

end
