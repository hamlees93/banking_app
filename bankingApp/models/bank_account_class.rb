require_relative 'readWriteHashes'

#A bank account class. Uses recursion to cycle through all features upon the command 'BankAccount.new'
#Allows uses to sign up, then log in next time they use it, check their accout balance, deposit funds, withdraw funds and view an account history


class BankAccount 
		
	attr_accessor :first_name, :username, :password, :user_hash, :user_data, :amount, :descriptor
		   
	#Do I need to have first_name, username, password listed below?
    def initialize first_name
        login_menu 
		@first_name = first_name.capitalize
        # @username = username
		# @password = password
		self.class.all << self
	end

	@bankaccounts = []

	#Not needed at the mo - can be a feature to add later, although kind of redundant with the files holding 
	#UPDATED: REMOVE self class after its been added to other class docos
	class << self
		def all
			@bankaccounts
		end

		def count
			@bankaccounts.count
        end
	end
	

	#Finds out whether the user is new or returning, then takes them to their neccessary loading page
	def login_menu
		login_display
        option = gets.chomp.downcase
        if option == "1" || option == "1." || option == "new user"
            get_user_info
        elsif option == "2" || option == "2." || option == "returning user"
            login
        elsif option == "3" || option == "3." || option == "exit"
            goodbye
        else
			puts "Check your input and make sure you are selecting a number. "
			sleep(2)
            login_menu
        end
    end


	#Gets user to enter their first name, then their username. This username is checked via 'new_user?' to ensure it is unique and is not in use. Once a unqiue username has been verified, the user enters their password. The 'create_new_user' is called at the end of the function
    def get_user_info
        system("clear")
        puts "Thank you for choosing the Bank of Hamish for all your banking needs."
        puts
        puts "Please enter your first name. "
        @first_name = gets.chomp.capitalize
        puts
        puts "Lovely to meet you, #{@first_name}."
        sleep(3)
        system("clear")
        puts "Please select a username."
        puts "This must be a unique name, so try think of something special."
        @username = gets.chomp.downcase
        new_user?
        puts
        puts "Good selection. Your username is #{@username}"
        sleep(3)
        system("clear")
        puts "Ok #{@first_name}, last bit of information we need from you is a password."
        puts "Make this something thats easy to remember!"
        @password = gets.chomp
        puts 
        puts "Awesome! You're all signed up #{@first_name}!"
        puts "Next time you enter the app, you can chose 'returning user' and login using #{@username} and your password."
        sleep(5)
        @balance = 0.00
        create_new_user
    end


	#Looks to see if a file exists with their username attached. If so, the username is already in use and the user must select a new one. If not, the username is not in use, and they may proceed
    def new_user?
        while File.exist?("models/userDetails/#{@username}.txt") == true
            puts "Sorry #{@first_name}, the username '#{@username}' is taken. Please try another."
            @username = gets.chomp.downcase
        end
	end
	
	
	#Calls the 'user-details' function, and uses the hash it creates. It uses the 'readWriteHashes' function to create a file with the same name as their username, and adds the '@user_data' hash to the new file, before taking the user to the menu
	def create_new_user
		user_details
        append_to_file("models/userDetails/#{@username}.txt", @user_data)
		menu
	end


	#Creates a new hash, and stores the user entered first_name, username and password in it, as well as the initial balance of $0
	def user_details
		@user_data = Hash.new
		@user_data["first_name"] = @first_name
		@user_data["username"] = @username
		@user_data["password"] = @password
		@user_data["balance"] = @balance
	end


	#Creates a function for an existing user to login. The user enters their username. This is checked agaisnt the files in the 'userDetails' directory. If a file with the same username exists, it means the username exists. The user is then asked for a password, which is checked agaisnt the password in the 'load_data' function. Before taking the user to the menu
	def login 
		system("clear")
		puts "Please enter your unique username or 'cancel' if you are a new user"
		username = gets.chomp.downcase
		if File.exist?("models/userDetails/#{username}.txt") == true
			puts "Success! Username #{username} exists!"
			@username = username
			sleep(2)
		elsif username == 'cancel'
			login_menu
		else
			puts "Unfortunately that username does not exist."
			sleep(2)
			login
		end
		load_data
		system("clear")
		puts "Welcome back #{@first_name}!"
		puts "Please enter your password."
		password = gets.chomp
		if password == @password
			puts "Great success! Password validated!"
			sleep(2)
			password_check = true
		else
			puts "Unfortunately, the password didn't match the one on file. Please try again. "
			sleep(2)
			login
		end
		menu
    end


	#Uses the read_from_file function from the 'readWriteHases' to gain access to the data in the file. @balance gets its value from the "balance" key in the last line of the file, as that will be the most up-to-date. The other values are gained from the matching keys in the first line, which have been sent there from the 'create_new_user' function
	def load_data
		@user_hash = read_from_file("./models/userDetails/#{@username}.txt")
		@balance = user_hash[-1]["balance"]
		@password = user_hash[0]["password"]
		@first_name = user_hash[0]["first_name"]
		@username = user_hash[0]["username"]
	end


	#Loads the menu_display function. Then asks the user for input on which option they would like to access. The user will be taken to their respective choice
	def menu
		menu_display
		decision = gets.chomp.downcase
		if decision == '1' || decision == '1.' || decision == 'balance'
			check_balance
		elsif decision == '2' || decision == '2.' || decision == 'deposit'
			deposit
		elsif decision == '3' || decision == '3.' || decision == 'withdraw'
			withdraw
		elsif decision == '4' || decision == '4.' || decision == 'history'
			history
		elsif decision == '5' || decision == '5.' || decision == 'exit'
			goodbye
		else
			"Please check your input and enter the correct number. "
			sleep(3)
			menu
		end
	end


	#Calls on the check_balance_display function to show the user how much they have in their account. It will leave it on the screen for '5 seconds' before automatically taking the user back to the menu 
	def check_balance
		system('clear')
		check_balance_display
        menu
	end


	#Saves the instance variable '@descriptor' with the string 'deposit' for the transaction_details function. Asks the user for the amount they would like to deposit, and saves it under 'amount'. Turns the instance variable balance into a normal variable balance, as the compiler was throwing up errors when trying to amount amount to the instance varaible. Prints the successful deposit, then sends the user to transaction_details
	def deposit
		system("clear")
		@descriptor = "Deposit"
		puts "How much would you like to deposit? "
		@amount = gets.chomp.to_f
		#Didn't like the transaction on the instance variable.to_f, so created temporary balance variable
		balance = @balance.to_f
        balance += @amount 
		puts "Successful deposit of $#{@amount}!"
        puts "Your account is now worth $#{balance}"
        sleep(2)
        @balance = balance
        transaction_details
	end
	
  
	#Saves the instance variable '@descriptor' with the string 'withdrawal' for the transaction_details function. Asks the user for the amount they would like to withdraw, and saves it under 'amount'. If balance is less than amount, it means the user doesn't have enough money in their account. They will get the option for a smaller amount, which, if taken, will repeat the variable, otherwise will send the user back to the menu. When the user has enough money for the withdrawal, their balance will be reduced by 'amount' and the transaction will be sent to transaction_details
	def withdraw
		system("clear")
		@descriptor = "Withdrawal"
		puts "How much would you like to withdraw? "
		@amount = gets.chomp.to_f
		balance = @balance.to_f
		if (balance - @amount) < 0
			puts "Unfortunately you do not have enough money. Your current balance is #{balance}. Would you like to try a smaller amount? "
			smaller_amount = gets.chomp.downcase
			if smaller_amount == 'yes' || smaller_amount == 'y'
				sleep(2)
				withdraw
			else
				sleep(2)
				menu
			end
		else
			balance -= @amount
			puts "Successful withdrawal of #{@amount}"
			puts "Your new balance is $#{balance}"
			sleep(3)
		end
		@balance = balance
		transaction_details
	end	


	#Creates a hash that stores a key 'history' and a key 'balance'. History takes a timestamp, says whether it was a withdrawal or deposit, says the amount, and posts the updated balance. The 'balance' key saves the updated balance. And this hash is added to the end of the users file and the user is sent back to the menu
	def transaction_details
		transaction_details = Hash.new
		transaction_details["history"] = "#{Time.now.strftime("%d/%m/%Y at %H:%M")} - #{@descriptor} worth $#{@amount}. Balance is now: $#{@balance}"
		transaction_details["balance"] = @balance
		append_to_file("models/userDetails/#{@username}.txt", transaction_details)
		menu
	end


	#Sets the variable 'user_input' before the while loop, so not to call an error with the if/else statement, but so the user input will come after the display. Redundant_variable is set before the while loop to keep the while loop going. The loop will only be broken when the user enters "menu", as it will turn redundant_variable into true. Loads the contents of their user file into the variable 'transactions'. i is set as the number of lines in the file. n is created to print out many transactions there are. It loops through all the lines in the file and prints out the 'history' key from the file
	def history
		user_input = nil
		redundant_variable = true
		while redundant_variable == true
			system("clear")
			transactions = read_from_file("./models/userDetails/#{@username}.txt")
			i = transactions.length - 1
			n = i
			message = nil
			if user_input == 'more'
				n_transactions = "ALL"
			elsif user_input == 'menu'
				redundant_variable = false
			else
				#FIXME: COULD fix grammar of n = 1, by doing an if .length == 2, then ...reword it
				if transactions.length < 6 
					n = transactions.length - 1
				else
					n = 5
				end
				message = "or 'more' to see all transactions."
				n_transactions = "#{n} most recent"
			end
			puts "#{n_transactions} transactions for #{@username}:"
			puts
			puts "---- Start of list ------"
			puts
			n.times do 
				puts "	# #{transactions[i]["history"]}"
				puts 
				i -= 1
			end
			puts
			puts "---- End of list ------"
			puts
			puts "Type 'menu' to return to menu #{message}"
			if redundant_variable == true
				user_input = gets.chomp.downcase
			end
		end
		menu
	end


	#A simple display to show the user the possible options of the login screen
	def login_display
		system("clear")
        puts "#######################"
        puts "#                     #"
        puts "#      Welcome!!      #"
        puts "#                     #"
        puts "#  Please select an   #"
        puts "#       option        #"
        puts "#                     #"
        puts "#  1. New User        #"
        puts "#                     #"
        puts "#  2. Returning User  #"
        puts "#                     #"
        puts "#  3. Exit            #"
        puts "#                     #"
		puts "#######################"
	end


	#Menu for when user is logged in. Will show potential options (balance, withdrawal, deposit, history and exit). This function will constantly be called, until user selects exit
    def menu_display
        system("clear")
		puts "##############################"
		puts "#                            #"
		puts "#      Select a number       #"
		puts "#         from below         #"
		puts "#                            #"
		puts "#      1. Balance            #"
		puts "#      2. Deposit            #"
		puts "#      3. Withdraw           #"
		puts "#      4. History            #"
		puts "#      5. Exit               #"
		puts "#                            #"
		puts "#                            #"
		puts "##############################"
    end
    

	#A simple display showing the user their current balance
	def check_balance_display
		puts "#######################"
		puts "#                     #"
		puts "#  Hi #{@username},          "
		puts "#                     #"
		puts "#   Your current      #"
		puts "#                     #"
		puts "#    balance is:      #"
		puts "#                     #"
		puts "#       $#{@balance}          "
		puts "#                     #"
		puts "#                     #"
		puts "#######################"
        sleep(5) 
	end


	#A simple display with a goodbye message. There are no links to other functions, so the app will exit when this function is called
	def goodbye 
		system("clear")
        puts "#######################"
        puts "#                     #"
        puts "#    Thank you for    #"
        puts "#                     #"
        puts "#    visiting the     #"
        puts "#                     #"
        puts "#    Bank of Hamish   #"
        puts "#                     #"
        puts "#      GOODBYE!       #"
        puts "#                     #"
        puts "#                     #"
		puts "#######################"
	end
	

	#A delete function that will remove the user's file. Then if the username is ever used to login again, they won't find the file, thus making the user non-existant. 
	#At a later date, if you start using 'self' get the index for the account that needs to be deleted, then 'delete_at'
	def delete
		begin
			File.open("models/userDetails/#{@username}.txt", "r") do |f|
			  File.delete(f)
			end
		rescue Errno::ENOENT
		end
	end
end