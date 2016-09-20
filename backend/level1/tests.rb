require_relative "class/rental"
require_relative "class/car"
require_relative "main"
require 'minitest/autorun'

class TestRental < MiniTest::Unit::TestCase 
 
 	def setup
    @rental_one = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 100})
    
    @rental_two = Rental.new({"id" => 2, "car_id" => 1, "start_date" => "2017-12-14", "end_date" => "2017-12-18", "distance" => 550})
    
    @rental_three = Rental.new({"id" => 3, "car_id" => 2, "start_date" => "2017-12-8", "end_date" => "2017-12-10", "distance" => 150})
    
    @rental_no_day = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-7", "distance" => 100})
    
    @rental_no_distance = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-8", "distance" => 0})
    
    @car_one = Car.new({"id" => 1, "price_per_day" => 2000, "price_per_km" => 10})
   	
    @car_two = Car.new({"id" => 2, "price_per_day" => 3000, "price_per_km" => 15})
  end
 
  def test_rental
    assert_equal(3, @rental_one.days_nb)
    assert_equal(5, @rental_two.days_nb)
    assert_equal(3, @rental_three.days_nb)
    assert_equal(0, @rental_no_day.days_nb)
    assert_equal(1, @rental_no_distance.days_nb)
  end
  
  def test_compute_price
  	assert_equal(7000, @rental_one.price)
  	assert_equal(15500, @rental_two.price)
  	assert_equal(11250, @rental_three.price)
  end
 
end
