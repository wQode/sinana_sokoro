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

  # application handles the data as a hash
  serialize :words, Hash 
  # application handles the data as an array
  serialize :exceptions, Array 

  # callback functions, before saving data to database
  before_save :save_words 
  before_save :save_exceptions



  # sanitizes the text data
  def normalized_original(original)
    # filters non-word characters and spaces
    original.gsub(/[^a-zA-Z ]/,'').gsub(/ +/,' ')
  end

  # main function that builds the word count and word list
  def count_words(original)
    wordcount = {}

    filtered_list(normalized_original(original)).each do |word|
      # strip remove whitespaces and do word
      # exclude words whose length is less than 3
      if word.strip.size >= 3 
        # if any of the keys in wordcount includes word, wordcount[word] = +1
        unless wordcount.key?(word.strip) 
          wordcount[word.strip] = 1 
        else
          wordcount[word.strip] += 1
        end
      end
    end
    self.filter_word_value(wordcount, count)
  end

  # filtering exceptions 
  def filtered_list(original)
    original.downcase.split(' ').reject do |word|
      self.exceptions.include?(word)
    end
  end

  # excluding words that occurs less than 1 instances
  def filter_word_value(words, value = 1)
    words.reject {|k,v| v < Integer(value) }
  end

  # builds the format for D3 library to display visualisation
  def bucket_words
    output = []
    bucket = 0

    self.words.each_slice(1) do |words|
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

  # callback functions before saving
  def save_words
    self.words = count_words(self.original)
  end 

  def save_exceptions
    self.exceptions = self.exceptions.split(/\s*,\s*/) if self.exceptions.kind_of? String
  end

end
