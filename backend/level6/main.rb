require "json"
require "date"

file = File.read('data.json')
parsed_file = JSON.parse(file);

$cars_array = parsed_file['cars'];
$rentals_array = parsed_file['rentals'];
rental_modifications_array = parsed_file['rental_modifications']

def get_first_from_associative(associative_array, key, value)

	for l in 0..associative_array.length-1
		if(associative_array[l][key] === value)
			result = associative_array[l]
			break
		end
	end
	
	return result
end

def get_car(id)
	return get_first_from_associative($cars_array, "id", id)
end

def get_rental(id)
	return get_first_from_associative($rentals_array, "id", id)
end

def get_days_number(start_date, end_date)

	return Integer(Date.parse(end_date) - Date.parse(start_date)) + 1
	
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

	final_content = { "rental_modifications" => content }

	out_file = File.new("myoutput.json", "w")
	out_file.puts(final_content.to_json)
	out_file.close
	
end

def get_rental_actions(rental)

	car = get_car(rental["car_id"]);
	days_nb = get_days_number(rental['start_date'], rental['end_date'])
	
	price = compute_price(days_nb, rental['distance'], car['price_per_day'], car['price_per_km'])
	
	options = compute_options(rental['deductible_reduction'], days_nb, 400)
	
	commission = compute_commission(price, days_nb, 100)
	
	driver = get_action("driver", false, price+options['deductible_reduction'])
	owner = get_action("owner", true, price-commission['insurance_fee']-commission['assistance_fee']-commission['drivy_fee'])
	insurance = get_action("insurance", true, commission['insurance_fee'])
	assistance = get_action("assistance", true, commission['assistance_fee'])
	drivy = get_action("drivy", true, commission['drivy_fee']+options['deductible_reduction'])
	
	return {"id" => rental["id"], "actions" => [driver, owner, insurance, assistance, drivy]}
	
end


result = []

for i in 0..rental_modifications_array.length-1

	rental_modif = rental_modifications_array[i]
	rental = get_rental(rental_modif['rental_id'])
	
	rental_with_modif = JSON.parse(rental.to_json)
	if(rental_modif['start_date'])
		rental_with_modif['start_date'] = rental_modif['start_date']
	end
	if(rental_modif['end_date'])
		rental_with_modif['end_date'] = rental_modif['end_date']
	end
	if(rental_modif['distance'])
		rental_with_modif['distance'] = rental_modif['distance']
	end
	
	rental_actions = get_rental_actions(rental)['actions']
	rental_with_modif_actions = get_rental_actions(rental_with_modif)['actions']
	result_actions = []
	
	for j in 0..rental_actions.length-1
	
		rental_amount = get_first_from_associative(rental_actions, 'who', rental_actions[j]['who'])['amount']
		
		rental_with_modif_amount = get_first_from_associative(rental_with_modif_actions, 'who', rental_with_modif_actions[j]['who'])['amount']
		
		diff_amount = rental_with_modif_amount - rental_amount
		
		result_actions[j] = get_action(rental_actions[j]['who'], rental_actions[j]['who'] == 'driver' ? diff_amount<0 : diff_amount>0, diff_amount.abs)
		
	end
	
	result[i] = {"id" => rental_modif["id"], "rental_id" => rental_modif["rental_id"],"actions" => result_actions}
	
end

write_output_file(result)


