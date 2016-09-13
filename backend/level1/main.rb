require "json"
require "date"

file = File.read('data.json')
parsed_file = JSON.parse(file);

$cars_array = parsed_file['cars'];
rentals_array = parsed_file['rentals'];

def get_car(id)

	for j in 0..$cars_array.length-1
		if($cars_array[j]["id"] === id)
			car = $cars_array[j]
			break
		end
	end
	
	return car
end

def write_output_file(content)

	final_content = { "rentals" => content }

	out_file = File.new("myoutput.json", "w")
	out_file.puts(final_content.to_json)
	out_file.close
	
end

result = []

for i in 0..rentals_array.length-1

	rental = rentals_array[i]
	car = get_car(rental["car_id"]);
	days_nb = Integer(Date.parse(rental['end_date']) - Date.parse(rental['start_date'])) + 1
	
	price = days_nb*car['price_per_day'] + rental['distance']*car['price_per_km']
	
	result[i] = {"id" => rental["id"], "price" => price}
end

write_output_file(result)


