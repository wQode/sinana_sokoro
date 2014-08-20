require 'pry'

words = {
    "harry" => 2,
    "craig" => 1,
    "chicken" => 1,
    "words" => 11,
    "snail" => 8,
    "fish" => 7
}

output = []
bucket = 0

words.each_slice(3) do |words|
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
p output
# binding.pry