require "json"
require_relative "class/car"
require_relative "class/rental"

$INPUT_FILE = "json/data.json"
$OUTPUT_FILE = "json/myoutput.json"

input_file = JSON.parse(File.read($INPUT_FILE))

Car.parse_json input_file["cars"]
Rental.parse_json input_file["rentals"]

result = []
Rental.rentals.each{|rental|
	result << rental.to_result
}

output_file = File.new($OUTPUT_FILE, "w")
output_file.puts({"rentals" => result}.to_json)
output_file.close

