require 'json'

def get_all_people 
  begin
  resp = `curl -XPOST https://#{url}.pike13.com/desk/api/v3/reports/clients/queries \
   -H "Authorization: Bearer #{token}" \
   -H "Content-Type: application/vnd.api+json" \
   -d '{
     "data": {
       "type": "queries",
       "attributes": {
         "fields": [ "email","first_name","last_name" ,"address", "birthdate","phone","source_name","also_staff","completed_visits","custom_fields"],
         "sort": [ "key" ],
         "page": {
           "limit": 500
     	  ,"starting_after":"201801012243096483660005125649"
         }
       }
     }
  }'`
   # ,"starting_after":201605271923423636380002830796
 # # "starting_after":last_key
  f = JSON.parse resp
  puts f.inspect
  puts "\n get the email "
  fields = f["data"]["attributes"]["fields"]
  puts "fields are \n"
  puts fields.inspect
  theBPindex = 0
  fields.each_with_index do |field,i|
  	puts field
  	puts i
  	if field["display_name"] && field["display_name"] == "Blood Pressure"
  		theBPindex = i
  	end
  end
  f["data"]['attributes']['rows'].each do |row|
    email = row.first
    first_name = row[1]
    last_name = row[2]
    address = row[3]
    birthday = row[4]
    phone = row[5]

    bp = row[theBPindex.to_i]

    puts " attempt to add email for #{email} and bp #{bp} and phone #{phone}"
    puts row.inspect
    # add_mind(email,first_name,last_name,address,birthday,phone,bp)
  
  end

  last_key = f["data"]['attributes']['last_key']

  puts "last_key : #{last_key}"
  rescue Exception => e 
	puts e.inspect
  end

end

def get_people_plans
	# /desk/api/v3/reports/person_plans/queries
	 begin
  resp = `curl -XPOST https://yoururl.pike13.com/desk/api/v3/reports/person_plans/queries \
   -H "Authorization: Bearer #{token}" \
   -H "Content-Type: application/vnd.api+json" \
   -d '{
     "data": {
       "type": "queries",
       "attributes": {
         "fields": [ "email","product_name","commitment_length","is_available"],
         "sort": [ "email" ],
         "page": {
           "limit": 500
         },
         "filter": ["eq", "is_available", "t"]
       }
     }
  }'`
  f = JSON.parse resp
  puts f.inspect
  puts "TOTAL LENGTH"
  puts f
  puts f["data"]['attributes']['rows'].length
  # puts f["data"]["attributes"]["rows"].length.inspect
  # puts f[:attributes][:rows]
  rescue
  end
end
