require "json"
require_relative "class/car"
require_relative "class/rental"
require_relative "class/rental_modif"

$INPUT_FILE = "json/data.json"
$OUTPUT_FILE = "json/myoutput.json"

input_file = JSON.parse(File.read($INPUT_FILE))

Car.parse_json input_file["cars"]
Rental.parse_json input_file["rentals"]
Rental_modif.parse_json input_file['rental_modifications']

result = []
Rental_modif.rental_modifs.each{|rental_modif|
	result << rental_modif.to_result
}

output_file = File.new($OUTPUT_FILE, "w")
output_file.puts({"rental_modifications" => result}.to_json)
output_file.close


