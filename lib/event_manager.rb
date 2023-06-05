require 'csv'
require 'erb'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def mode(array)
  array.group_by{ |e| e }.group_by{ |k, v| v.size }.max.pop.map{ |e| e.shift }
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def clean_phone_num(phone)
  bad_phone = ""
  phone = "%f" % phone if phone.include? "+"
  phone.gsub!(/[^0-9]/,"")
  case phone.length
  when 12..(1.0/0.0)
    bad_phone
  when 0..9
    bad_phone
  when 11
    if phone.index('1') == 0
      phone[1..-1]
    else
      bad_phone
    end
  when 10
    phone
  end
end

def best_hour(datetime)


end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
hours = []
weekday = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone = clean_phone_num(row[:homephone])
  hours << Time.strptime(row[:regdate], "%m/%d/%y %k:%M").hour
  weekday << Time.strptime(row[:regdate], "%m/%d/%y %k:%M").strftime("%A")

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)
end
puts "Best hour(s) to send are... #{mode(hours).join(", ")}"
puts "Best day(s) to send are... #{mode(weekday).join(", ")}"