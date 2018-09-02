require 'json'

# Run 'sudo gem install json' to install the JSON gem
# Documentation for the JSON gem on Github: https://github.com/flori/json#usage
# Some good articles on reading and appending to files in Ruby:
# https://alvinalexander.com/blog/post/ruby/how-open-file-read-contents-ruby
# https://alvinalexander.com/blog/post/ruby/example-how-append-text-to-file-ruby

# METHODS =====================

# Returns a hash as json
# Params:
# +data+:: +Hash+ takes a hash
def hash_to_json(data)
  JSON.generate(data)
end

# Returns json as a hash
# Params:
# +data+:: +Hash+ takes a hash
def json_to_hash(data)
  JSON.parse(data)
end

# Returns a mock hash data
def mock_hash
  { 'doggo' => 'woof', 'catto' => 'meow', 'birdo' => 'tweet' }
end

# Appends data as json to a file
# Params:
# +path+:: +String+ takes a path to a file
# +data+:: +Hash+ takes a Hash
def append_to_file(path, data)
  # See for more on Open method options:  https://ruby-doc.org/core-2.5.1/IO.html#method-c-new
  File.open(path, 'a') do |f|
    f.puts hash_to_json(data)
  end
end

# Reads a file of hashes, displays each hash and validates each is a hash
# +path+:: +String+ takes a path to a file
def read_from_file(path)
  array = []
  File.open(path, 'r') do |f|
    f.each_line do |line|
      hash = json_to_hash(line)
      array.push(json_to_hash(line)) # You could use eval instead of the JSON gem to convert a stringified hash back to a hash, but: https://stackoverflow.com/questions/637421/is-eval-supposed-to-be-nasty
    end
  end
  array
end

# Prints the values of an array and whether they are Hashes
# +hashes+:: +Array+ takes an array of hashes
def validate_hashes(hashes)
  hashes.each do |hash|
    result = hash.is_a?(Hash)
    puts 'Value: ' + hash.to_s + ', Is a hash? ' + result.to_s
  end
end

