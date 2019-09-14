class AirportFuelInventory
	#to Initialize default data
	def initialize
		@airports_info = {
			1 =>{"Airport Name" => "Indira Gandhi International Airport,Delhi", "Fuel Capacity" => 500000,"Fuel Available" => 25066, "transactions" => [] },
			2 =>{"Airport Name" => "Rajiv Gandhi International Airport,Hyderabad", "Fuel Capacity" => 500000,"Fuel Available" => 350732,  "transactions" => []  },
			3 =>{"Airport Name" => "Chhatrapati Shivaji International Airport, Mumbai", "Fuel Capacity" => 500000,"Fuel Available" => 288467,  "transactions" => []  },
			4 =>{"Airport Name" => "Chennai International Airport, Chennai", "Fuel Capacity" => 500000,"Fuel Available" => 497460,  "transactions" => []  },
			5 =>{"Airport Name" => "Kempegowda International Airport,Bangalore", "Fuel Capacity" => 500000,"Fuel Available" => 123456,  "transactions" => [] }
		}
	end
	#To choose user option
	def get_user_input
		print_user_manual
		puts "Enter your Option:"
		user_input = gets.chomp.to_i
		process_input(user_input)
	end
	#To process user option
	def process_input(input)
		case input.to_i
		when 1
			show_airport_info
		when 2
			fill_tank
		when 3
		   fill_aircraft
		when 4
		   show_report
		when 8
			exit
		else
			puts "You selected invalid option:"
			get_user_input
		end
	end
	#This method will generate report
	def show_report
		@airports_info.each do |airport_id,airport_data|
			puts "------"
			puts "Airport:#{airport_data["Airport Name"]}"
			trasactions = airport_data["transactions"]
			if !trasactions.empty?
				puts "Date/time\t\t\t\t\t Type\t\t\t\ Fuel\t\t\t\ Aircraft"
				trasactions.each do |trasaction|
					puts "#{trasaction['Date/Time']}\t\t\t\ #{trasaction['Type']} \t\t\t\ #{trasaction['Fuel']} \t\t\t\ #{trasaction['Aircraft']}"
				end
			end
			puts "------"
		end
		get_user_input
	end
	def fill_aircraft
		puts "Enter Airport ID:"
		airport_id = gets.chomp.to_i
		puts "Enter Aircraft Code:"
		aircraft_code = gets.chomp
		puts "Enter Fuel (ltrs):"
		fuel = gets.chomp.to_i
		validate_fuel(fuel)
		update_fill_record(airport_id,fuel,aircraft_code)
	end
	def validate_fuel(fuel)
		fuel > 0 ? true :  validation_error("Failure: Invalid Fuel")
	end
	def update_fill_record(airport_id,fuel,aircraft_code)
		airport = find_airport(airport_id)
		if !airport.empty?
			updated_fuel = verify_fuel_availability(airport,fuel)
			msg = "Success: Request for the has been fulfilled"	
			save_fuel_transaction(airport,fuel,"OUT",aircraft_code)
			update_fuel_record(airport,updated_fuel,msg)
		else
			validation_error("No record Found with this Airport ID")
		end
	end
	#
	def verify_fuel_availability(airport,filling_fuel)
		available_fuel = airport["Fuel Available"]
		updated_fuel = available_fuel - filling_fuel
		updated_fuel < 0 ? validation_error("Failure: Request for the fuel is beyond availability at airport") : updated_fuel
	end
	def fill_tank
		puts "Enter Airport ID:"
		airport_id = gets.chomp.to_i
		puts "Enter Fuel (ltrs):"
		fuel = gets.chomp.to_i
		validate_fuel(fuel)
		update_record(airport_id,fuel)
	end
	def update_record(airport_id,fuel)
		airport = find_airport(airport_id)
		if !airport.nil?
			updated_fuel = verify_tank_capacity(airport,fuel)
			msg = "Success: Request for the has been fulfilled"
			save_fuel_transaction(airport,fuel,"IN",nil)
			update_fuel_record(airport,updated_fuel,msg)
		else
			validation_error("Error: No record Found with this Airport ID.")
		end
	end
	#This method will record all fuel transactions
	def save_fuel_transaction(airport,fuel,type,aircraft_name)
		transaction = {"Date/Time"=> Time.now,"Type" =>type,"Fuel"=>fuel,"Aircraft"=>aircraft_name}
		airport["transactions"]<< transaction
	end
	#This method to check capacity of tank
	def verify_tank_capacity(record,adding_fuel)
		available_fuel = record["Fuel Available"]
		capacity  = record["Fuel Capacity"]
		updated_fuel = adding_fuel+available_fuel
		updated_fuel <= capacity ? updated_fuel  : validation_error("Error: Goes beyond fuel capacity of the airport.")
	end
	#This method to update fuel info
	def update_fuel_record(airport,updated_fuel,msg)
		airport["Fuel Available"] = updated_fuel
		validation_error(msg)
	end
	#This method to finf airport
	def find_airport(airport_id)
		@airports_info[airport_id]
	end
	#This method list all airports info. along with fuel availability
	def show_airport_info
		puts "--------------------------------------------------------------------------------"
		puts "Airport Name \t\t\t\t\t\t\t Fuel Available"
		puts "--------------------------------------------------------------------------------"
		@airports_info.each do |key,data|
			puts "#{data['Airport Name']}\t\t\t #{data['Fuel Available']}"
		end
		puts "--------------------------------------------------------------------------------"
	
		get_user_input
	end
	#this method can print error message.
	def validation_error(msg)
		puts msg
		get_user_input
	end
	#User index
	def print_user_manual
		puts "Enter 1 to Show Fuel Summary at all Airports"
		puts "Enter 2 to Updating Fuel Inventory of a selected Airport"
		puts "Enter 3 to Fill Aircraft"
		puts "Enter 4 to Show Fuel Transaction for All Airport"
		puts "Enter 8 to exit"
	end
end
afi = AirportFuelInventory.new
afi.get_user_input



