require "date"
require_relative "car"

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
		return self.days_nb*@car.price_per_day + @distance*@car.price_per_km
	end
	
	def to_result
  	{"id" => @id, "price" => self.price}
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
