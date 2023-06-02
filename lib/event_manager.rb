puts 'Event Manager Initialized!'

if File.exist?('event_attendees.csv')
    puts "Found it..."
else
    puts "I can't find the file!"
    exit
end

#contents = File.read('event_attendees.csv')
#puts contents

lines = File.readlines('event_attendees.csv')
lines.each do |line|
    columns = line.split(",")
    p columns
end