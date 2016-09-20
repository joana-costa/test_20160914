require_relative "class/rental"
require_relative "class/car"
require_relative "main"
require 'minitest/autorun'

class TestRental < MiniTest::Unit::TestCase 
 
 	def setup
    @rental_one = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-8", "distance" => 100})
    
    @rental_two = Rental.new({"id" => 2, "car_id" => 1, "start_date" => "2015-03-31", "end_date" => "2015-04-01", "distance" => 300})
    
    @rental_three = Rental.new({"id" => 3, "car_id" => 1, "start_date" => "2015-07-3", "end_date" => "2015-07-14", "distance" => 1000})
    
    @rental_no_day = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-7", "distance" => 100})
    
    @rental_no_distance = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-8", "distance" => 0})
    
    @car_one = Car.new({"id" => 1, "price_per_day" => 2000, "price_per_km" => 10})
  end
 
  def test_days_nb
    assert_equal(1, @rental_one.days_nb)
    assert_equal(2, @rental_two.days_nb)
    assert_equal(12, @rental_three.days_nb)
    assert_equal(0, @rental_no_day.days_nb)
  end
  
  def test_compute_price
  	assert_equal(3000, @rental_one.price)
  	assert_equal(6800, @rental_two.price)
  	assert_equal(27800,@rental_three.price)
  end
  
  def test_compute_commission
  	assert_equal(450, @rental_one.commission.insurance_fee)
  	assert_equal(100, @rental_one.commission.assistance_fee)
  	assert_equal(350, @rental_one.commission.drivy_fee)
  	
  	assert_equal(1020, @rental_two.commission.insurance_fee)
  	assert_equal(200, @rental_two.commission.assistance_fee)
  	assert_equal(820, @rental_two.commission.drivy_fee)
  	
  	assert_equal(4170, @rental_three.commission.insurance_fee)
  	assert_equal(1200, @rental_three.commission.assistance_fee)
  	assert_equal(2970, @rental_three.commission.drivy_fee)
  end
 
end
