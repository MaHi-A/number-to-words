class NumberToWords
  attr_reader :phone_number, :dictionary, :highlevel_matched_words, :number_mappings_list

  def initialize(phone_number)
    @starts_at = Time.now
    @phone_number = phone_number.to_s
    @dictionary = {}
    @number_letters_mapping_hash = {
      '2' => ['a', 'b', 'c'], '3' => ['d', 'e', 'f'], 
      '4' => ['g', 'h', 'i'], '5' => ['j', 'k', 'l'], 
      '6' => ['m', 'n', 'o'], '7' => ['p', 'q', 'r', 's'],
      '8' => ['t', 'u', 'v'], '9' => ['w', 'x', 'y', 'z']
    }
  end

  def phone_number_matching_words
    return 'phone number cannot be nil or 0 or 1 or phone number should have 10 digits' if prerequisites_not_satisfied
    
    read_dictionary
    highlevel_matching_words
    response = final_matching_words.sort_by { |input1, input2| input1 }

    all_combinations = number_mappings_list.shift.product(*number_mappings_list).map(&:join)
    response << (all_combinations & dictionary[number_mappings_list.length + 1]).join(', ')
    puts "Time taken for the execution #{Time.now.to_f - @starts_at.to_f}"
    puts response.inspect
  end

  def highlevel_matching_words
    @number_mappings_list = phone_number.chars.map { |char| @number_letters_mapping_hash[char] }
    max_length = number_mappings_list.length - 1;

    # starting from 2 as the minimum word should be 3 characters
    @highlevel_matched_words = (2..max_length).each_with_object({}) do |input, highlevel_matched_words|
      minimum_number_mappings_list = number_mappings_list[0..input]
      rest_of_the_number_mappings_list = number_mappings_list[input + 1..max_length]
      
      next if minimum_number_mappings_list.length < 3 || rest_of_the_number_mappings_list.length < 3
      minimum_words_combination = minimum_number_mappings_list.shift.product(*minimum_number_mappings_list).map(&:join)
      rest_of_the_words_combination = rest_of_the_number_mappings_list.shift.product(*rest_of_the_number_mappings_list).map(&:join)
      highlevel_matched_words[input] = [(minimum_words_combination & dictionary[input + 1]), (rest_of_the_words_combination & dictionary[max_length - input])]
    end
  end

  def final_matching_words
    highlevel_matched_words.each.each_with_object([]) do |(key, combinataions), response|
      next if combinataions.first.empty? || combinataions.last.empty?
     combinataions.first.product(combinataions.last).each do |combo_words|
        response << combo_words
      end
    end
  end

  def read_dictionary
    file_path = '/Users/maheshanethala/Downloads/dictionary.txt'
    File.foreach(file_path) do |word|
      word = word.chop.downcase
      dictionary[word.length] = dictionary[word.length].nil? ? [word] : dictionary[word.length].push(word)
    end
  end

  def prerequisites_not_satisfied
    phone_number.nil? || phone_number.include?('0' || '1') || !phone_number.length.eql?(10)
  end
end

NumberToWords.new(2282668687).phone_number_matching_words

