require "date"
require_relative "rental"
require_relative "action"

class Rental_modif
	attr_reader :id, :rental, :start_date, :end_date, :distance
  
  def initialize hash
  	raise "rental_modif json error" unless (hash['id'].is_a?(Integer) && hash['rental_id'].is_a?(Integer))
  	
    @id = hash['id']
    @rental = Rental.get_rental hash['rental_id']
    @start_date = hash['start_date']
    @end_date = hash['end_date']
    @distance = hash['distance']
  end  
  
  def get_rental_hash 
  	start_date = @start_date ? @start_date : @rental.start_date
  	end_date = @end_date ? @end_date : @rental.end_date
  	distance = @distance ? @distance : @rental.distance
  	return {"id" => @id, "car_id" => @rental.car.id, "start_date" => start_date, "end_date" => end_date, "distance" => distance, "deductible_reduction" => @rental.deductible_reduction}
  end
  
	def actions
		actions = []
		rental_with_modif = Rental.new(self.get_rental_hash)
	
		@rental.actions.each_with_index{|action, index|
			actions << Action.new(action.who, rental_with_modif.actions[index].signed_amount - action.signed_amount)
		}
		return actions
	end
	
	def to_result
  	{"id" => @id, "rental_id" => @rental.id, "actions" => Action.array_to_json(self.actions)}
	end
  
  # STATIC
  
  def self.parse_json json
  	@@rental_modifs = []
  	json.each{|rental_modif|
  		@@rental_modifs << Rental_modif.new(rental_modif)
  	}
  end
  
  def self.rental_modifs
  	@@rental_modifs
  end
end
