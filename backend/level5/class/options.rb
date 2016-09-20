class Options
  attr_reader :deductible_reduction
  
  def initialize deductible_reduction
  	raise "options json error" unless (deductible_reduction.is_a?(Integer))
  	
    @deductible_reduction = deductible_reduction
  end
  
  def to_json
  	{"deductible_reduction" => @deductible_reduction}
  end
end
