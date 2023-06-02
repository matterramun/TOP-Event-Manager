require 'csv'
puts 'Event Manager Initialized!'

if File.exist?('event_attendees.csv')
  puts 'Found it...'
else
  puts "I can't find the file!"
  exit
end

# contents = File.read('event_attendees.csv')
# puts contents

# lines = File.readlines('event_attendees.csv')
# lines.each.with_index do |line, index|
#    next if index == 0
#    columns = line.split(",")
#    name = columns[2]
#    p name
# end

contents = CSV.open(
  'event_attendees.csv', 
  headers: true, 
  header_converters: :symbol
)
contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]

  if zipcode.length > 5
    zipcode = zipcode.rjust(5,'0')
  elsif zipcode.length < 5
    zipcode = zipcode.slice(0..4)
  end

  puts "#{name} #{zipcode}"
end
