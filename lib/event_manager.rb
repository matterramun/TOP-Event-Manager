puts 'Event Manager Initialized!'

if File.exists?('event_attendees.csv')

    contents = File.read('event_attendees.csv')
    puts contents
else
    puts "I can't find the file!"
end