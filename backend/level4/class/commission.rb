class Commission
  attr_reader :insurance_fee, :assistance_fee, :drivy_fee
  
  def initialize(insurance_fee, assistance_fee, drivy_fee)
  	raise "commission json error" unless (insurance_fee.is_a?(Integer) && assistance_fee.is_a?(Integer) && drivy_fee.is_a?(Integer))
  	
    @insurance_fee = insurance_fee
    @assistance_fee = assistance_fee
    @drivy_fee = drivy_fee
  end
  
  def to_json
  	{"insurance_fee" => @insurance_fee, "assistance_fee" => @assistance_fee, "drivy_fee" => @drivy_fee}
  end

end
