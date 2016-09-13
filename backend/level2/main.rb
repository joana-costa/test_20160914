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

def compute_price(days, distance, price_day, price_km)

	computed_price = 0
	
	if(days >= 1)
		computed_price += price_day
		
		if(days >= 4)
			computed_price += price_day*0.9*3
			
			if(days >= 10)
				computed_price += price_day*0.7*6 + price_day*0.5*(days-10)
			else
				computed_price += price_day*0.7*(days-4)
			end
			
		else
			computed_price += price_day*0.9*(days-1)
		end
	end
	
	return Integer(computed_price) + distance*price_km
	
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
	
	price = compute_price(days_nb, rental['distance'], car['price_per_day'], car['price_per_km'])
	
	result[i] = {"id" => rental["id"], "price" => price}
end

write_output_file(result)


