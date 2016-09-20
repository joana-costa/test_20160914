class Action
  attr_reader :who, :type, :amount
  
  def initialize who, amount
  	raise "action json error" unless (who.is_a?(String) && amount.is_a?(Integer))
  	
    @who = who
    @type = amount > 0 ? "credit" : "debit"
    @amount = amount.abs
  end
  
  def signed_amount
  	@type == "debit" ? -@amount : @amount
  end
  
  def to_json
  	{"who" => @who, "type" => @type, "amount" => @amount}
  end
  
  # STATIC
  
  def self.array_to_json array
  	actions_json = []
		array.each{|action|
			actions_json << action.to_json
		}
		return actions_json
  end
end
