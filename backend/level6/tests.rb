require_relative "class/car"
require_relative "class/rental"
require_relative "class/rental_modif"
require_relative "main"
require 'minitest/autorun'

class TestRental < MiniTest::Unit::TestCase 
 
 	def setup
    @rental_one = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-8", "distance" => 100, "deductible_reduction" => true})
    
    @rental_two = Rental.new({"id" => 2, "car_id" => 1, "start_date" => "2015-03-31", "end_date" => "2015-04-01", "distance" => 300, "deductible_reduction" => false})
    
    @rental_three = Rental.new({"id" => 3, "car_id" => 1, "start_date" => "2015-07-3", "end_date" => "2015-07-14", "distance" => 1000, "deductible_reduction" => true})
    
    @rental_no_day = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-7", "distance" => 100, "deductible_reduction" => true})
    
    @rental_no_distance = Rental.new({"id" => 1, "car_id" => 1, "start_date" => "2017-12-8", "end_date" => "2017-12-8", "distance" => 0, "deductible_reduction" => true})
    
    @car_one = Car.new({"id" => 1, "price_per_day" => 2000, "price_per_km" => 10})
    
    @rental_modif_one = Rental_modif.new({"id" => 1, "rental_id" => 1, "end_date" => "2015-12-10", "distance" => 150})
    
    @rental_modif_two = Rental_modif.new({"id" => 2, "rental_id" => 3, "start_date" => "2015-07-4"})
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
  
  def test_compute_options
  	assert_equal(400, @rental_one.options.deductible_reduction)
  	assert_equal(0, @rental_two.options.deductible_reduction)
  	assert_equal(4800, @rental_three.options.deductible_reduction)
  end
  
  def test_compute_actions
    assert_equal("driver", @rental_one.actions[0].who)
  	assert_equal("debit", @rental_one.actions[0].type)
  	assert_equal(3400, @rental_one.actions[0].amount)
  	assert_equal("owner", @rental_one.actions[1].who)
  	assert_equal("credit", @rental_one.actions[1].type)
  	assert_equal(2100, @rental_one.actions[1].amount)
  	assert_equal("insurance", @rental_one.actions[2].who)
  	assert_equal("credit", @rental_one.actions[2].type)
  	assert_equal(450, @rental_one.actions[2].amount)
  	assert_equal("assistance", @rental_one.actions[3].who)
  	assert_equal("credit", @rental_one.actions[3].type)
  	assert_equal(100, @rental_one.actions[3].amount)
  	assert_equal("drivy", @rental_one.actions[4].who)
  	assert_equal("credit", @rental_one.actions[4].type)
  	assert_equal(750, @rental_one.actions[4].amount)
  
  	assert_equal("driver", @rental_two.actions[0].who)
  	assert_equal("debit", @rental_two.actions[0].type)
  	assert_equal(6800, @rental_two.actions[0].amount)
  	assert_equal("owner", @rental_two.actions[1].who)
  	assert_equal("credit", @rental_two.actions[1].type)
  	assert_equal(4760, @rental_two.actions[1].amount)
  	assert_equal("insurance", @rental_two.actions[2].who)
  	assert_equal("credit", @rental_two.actions[2].type)
  	assert_equal(1020, @rental_two.actions[2].amount)
  	assert_equal("assistance", @rental_two.actions[3].who)
  	assert_equal("credit", @rental_two.actions[3].type)
  	assert_equal(200, @rental_two.actions[3].amount)
  	assert_equal("drivy", @rental_two.actions[4].who)
  	assert_equal("credit", @rental_two.actions[4].type)
  	assert_equal(820, @rental_two.actions[4].amount)
  
  	assert_equal("driver", @rental_three.actions[0].who)
  	assert_equal("debit", @rental_three.actions[0].type)
  	assert_equal(32600, @rental_three.actions[0].amount)
  	assert_equal("owner", @rental_three.actions[1].who)
  	assert_equal("credit", @rental_three.actions[1].type)
  	assert_equal(19460, @rental_three.actions[1].amount)
  	assert_equal("insurance", @rental_three.actions[2].who)
  	assert_equal("credit", @rental_three.actions[2].type)
  	assert_equal(4170, @rental_three.actions[2].amount)
  	assert_equal("assistance", @rental_three.actions[3].who)
  	assert_equal("credit", @rental_three.actions[3].type)
  	assert_equal(1200, @rental_three.actions[3].amount)
  	assert_equal("drivy", @rental_three.actions[4].who)
  	assert_equal("credit", @rental_three.actions[4].type)
  	assert_equal(7770, @rental_three.actions[4].amount)
  end
 
	def test_compute_modif_actions
    assert_equal("driver", @rental_modif_one.actions[0].who)
  	assert_equal("debit", @rental_modif_one.actions[0].type)
  	assert_equal(4900, @rental_modif_one.actions[0].amount)
  	assert_equal("owner", @rental_modif_one.actions[1].who)
  	assert_equal("credit", @rental_modif_one.actions[1].type)
  	assert_equal(2870, @rental_modif_one.actions[1].amount)
  	assert_equal("insurance", @rental_modif_one.actions[2].who)
  	assert_equal("credit", @rental_modif_one.actions[2].type)
  	assert_equal(615, @rental_modif_one.actions[2].amount)
  	assert_equal("assistance", @rental_modif_one.actions[3].who)
  	assert_equal("credit", @rental_modif_one.actions[3].type)
  	assert_equal(200, @rental_modif_one.actions[3].amount)
  	assert_equal("drivy", @rental_modif_one.actions[4].who)
  	assert_equal("credit", @rental_modif_one.actions[4].type)
  	assert_equal(1215, @rental_modif_one.actions[4].amount)
  
  	assert_equal("driver", @rental_modif_two.actions[0].who)
  	assert_equal("credit", @rental_modif_two.actions[0].type)
  	assert_equal(1400, @rental_modif_two.actions[0].amount)
  	assert_equal("owner", @rental_modif_two.actions[1].who)
  	assert_equal("debit", @rental_modif_two.actions[1].type)
  	assert_equal(700, @rental_modif_two.actions[1].amount)
  	assert_equal("insurance", @rental_modif_two.actions[2].who)
  	assert_equal("debit", @rental_modif_two.actions[2].type)
  	assert_equal(150, @rental_modif_two.actions[2].amount)
  	assert_equal("assistance", @rental_modif_two.actions[3].who)
  	assert_equal("debit", @rental_modif_two.actions[3].type)
  	assert_equal(100, @rental_modif_two.actions[3].amount)
  	assert_equal("drivy", @rental_modif_two.actions[4].who)
  	assert_equal("debit", @rental_modif_two.actions[4].type)
  	assert_equal(450, @rental_modif_two.actions[4].amount)
	end
	
end
