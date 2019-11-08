require 'json'
TAB_WIDTH = " "

puts 'Please provide the file name with sample data:'
# file_name = gets.chomp
file_name = 'sample_two.json'

# read and parse the file
json_file = File.read(file_name)
data_hash = JSON.parse(json_file) # TODO: add error handling


# create the output file
file = File.open("output.txt", "w") # handle errros

data_hash.first['number'] = '1.'

data_hash.each_with_index do |record, idx|
  tabs = TAB_WIDTH * record['heading_level']
  prev_record = data_hash[idx-1] if idx >= 1

  # recursion?
  unless prev_record.nil?
    counter = 0
    last_el = data_hash[0..(idx-1)].find_all do |el|
        break if record['heading_level'] > 0 && counter != 0 && el['heading_level'] == 0 # break if block of 0 exceeded
        counter += 1 # method with index
        el['heading_level'] == record['heading_level']
    end&.last

    if last_el.nil?
      record['number'] = '1.' * (record['heading_level'].to_i + 1)
    else
      arr = last_el['number'].split('.')
      arr_count = arr.size
      counter = arr.last.to_i + 1
      arr = arr_count > 1 ? arr[0..(arr_count-2)].append(counter) : [counter.to_i]
      record['number'] = arr.join('.')
    end
  end

  str = "#{tabs}#{record['number']}.#{record['title']}\n".gsub('..', '.')

  file.write(str)
end

file.close
