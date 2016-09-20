class Car
	attr_reader :id, :price_per_day, :price_per_km

  def initialize hash
    raise "car json error" unless (hash['id'].is_a?(Integer) && hash['price_per_day'].is_a?(Integer) && hash['price_per_km'].is_a?(Integer))
    
    @id = hash['id']
    @price_per_day = hash['price_per_day']
    @price_per_km = hash['price_per_km']
  end
  
  # STATIC
  
  def self.parse_json json
  	@@cars = []
  	json.each{|car|
  		@@cars << Car.new(car)
  	}
  end
  
  def self.get_car id
		@@cars.each{|car|
				return car if(car.id === id)
		}
	
		raise "Car id #{id} not found"
  end
end
