require "date"
require_relative "car"
require_relative "commission"

class Rental
	attr_reader :id, :car, :commission, :start_date, :end_date, :distance
  
  def initialize hash
  	raise "rental json error" unless (hash['id'].is_a?(Integer) && hash['car_id'].is_a?(Integer) && hash['start_date'].is_a?(String) && hash['end_date'].is_a?(String) && hash['distance'].is_a?(Integer))
  	
    @id = hash['id']
    @car = Car.get_car hash['car_id']
    @start_date = hash['start_date']
    @end_date = hash['end_date']
    @distance = hash['distance']
  end
  
  def days_nb
  	days = Date.parse(@end_date) - Date.parse(@start_date)
  	if(days < 0)
  		return 0
  	end
  	return Integer(Date.parse(@end_date) - Date.parse(@start_date)) + 1
  end
  
	def price
		days = self.days_nb
		computed_price = 0

		if(days >= 1)
			computed_price += @car.price_per_day
			if(days >= 4)
				computed_price += @car.price_per_day*0.9*3
				if(days >= 10)
					computed_price += @car.price_per_day*0.7*6 + @car.price_per_day*0.5*(days-10)
				else
					computed_price += @car.price_per_day*0.7*(days-4)
				end
			else
				computed_price += @car.price_per_day*0.9*(days-1)
			end
		end

		return computed_price.round + @distance*@car.price_per_km
	end
  
  def commission
  	assistance_day_price = 100
		commission = 0.3*self.price
		insurance_fee = Integer(0.5*commission)
		assistance_fee = self.days_nb*assistance_day_price
		drivy_fee = Integer(commission - insurance_fee - assistance_fee)
		return Commission.new(insurance_fee, assistance_fee, drivy_fee)
	end
	
	def to_result
  	{"id" => @id, "price" => self.price, "commission" => self.commission.to_json}
	end
  
  # STATIC
  
  def self.parse_json json
  	@@rentals = []
  	json.each{|rental|
  		@@rentals << Rental.new(rental)
  	}
  end
  
  def self.rentals
  	@@rentals
  end
end
