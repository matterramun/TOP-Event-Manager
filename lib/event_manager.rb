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

contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |row|
  name = row[2]
  puts name
end
