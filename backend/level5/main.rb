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

def compute_commission(price, days, assistance_day_price)

	commission = 0.3*price
	
	insurance_fee = Integer(0.5*commission)
	assistance_fee = days*assistance_day_price
	drivy_fee = Integer(commission - insurance_fee - assistance_fee)
	
	computed_commission = {"insurance_fee" => insurance_fee, "assistance_fee" => assistance_fee, "drivy_fee" => drivy_fee}
	return computed_commission
	
end

def compute_options(is_deductible_reduction, days, deductible_reduction_day_price)

	deductible_reduction = 0
	
	if is_deductible_reduction
		deductible_reduction = days*deductible_reduction_day_price
	end
	
	computed_options = {"deductible_reduction" => deductible_reduction}
	return computed_options
	
end

def get_action(who, is_credit, amount)
	
	action = {"who" => who, "type" => is_credit ? "credit" : "debit", "amount" => amount}
	return action
	
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
	
	options = compute_options(rental['deductible_reduction'], days_nb, 400)
	
	commission = compute_commission(price, days_nb, 100)
	
	driver = get_action("driver", false, price+options['deductible_reduction'])
	owner = get_action("owner", true, price-commission['insurance_fee']-commission['assistance_fee']-commission['drivy_fee'])
	insurance = get_action("insurance", true, commission['insurance_fee'])
	assistance = get_action("assistance", true, commission['assistance_fee'])
	drivy = get_action("drivy", true, commission['drivy_fee']+options['deductible_reduction'])
	
	result[i] = {"id" => rental["id"], "actions" => [driver, owner, insurance, assistance, drivy]}
end

write_output_file(result)


