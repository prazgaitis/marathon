require 'open-uri'
require 'chronic_duration'

class PagesController < ApplicationController
	
	  class ContactForm < MailForm::Base
	  attribute :name,      :validate => true
	  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
	  attribute :file,      :attachment => true

	  attribute :message
	  attribute :nickname,  :captcha  => true

	  # Declare the e-mail headers. It accepts anything the mail method
	  # in ActionMailer accepts.
	  def headers
	    {
	      :subject => "My Contact Form",
	      :to => "paul.razgaitis@braintreepayments.com",
	      :from => %("#{name}" <#{email}>)
	    }
	  end
	end



	BEGINNER = {
				1 => [3, 5, 3, 0, 3, 5, 0], #0-7
				2 => [3, 5, 3, 0, 3, 6, 0], #8-14
				3 => [4, 3.8, 4, 0, 2, 3, 0], #15-21
				4 => [0, 5, 4, 0, 4, 6, 0], #22-28
				5 => [4, 6, 4, 0, 4, 7, 0], #29-35
				6 => [4, 6, 4, 0, 4, 6, 0], #36-42
				7 => [4, 5, 3, 0, 2, 6.2, 0], #43-49
				8 => [3, 5, 3, 0, 3, 6.2, 0], #50-56
				9 => [3, 6, 3, 0, 3, 8, 0], #57-63
				10 => [4, 6, 4, 4, 0, 4, 10, 0], #64-70
				11 => [4, 7, 4, 0, 5, 10, 0], #71-77
				12 => [4, 7, 5, 0, 5, 11, 0], #78-84
				13 => [5, 7, 5, 0, 5, 12, 0], #85-91
				14 => [5, 3.3, 5, 0, 5, 14, 0], #92-98
				15 => [4, 8, 0, 4, 0, 2, 13], #99-105
				16 => [0, 0, 5, 0, 5, 14, 0], #107-112
				17 => [5, 8, 5, 0, 5, 16, 0], #107-112
				18 => [5, 3.3, 5, 0, 5, 18, 0], #107-112
				19 => [5, 8, 5, 0, 5, 20, 0], #107-112
				20 => [5, 12, 5, 0, 5, 22, 0], #107-112
				21 => [0, 10, 5, 0, 4, 16, 0], #107-112
				22 => [4, 3.3, 5, 0, 4, 12, 0], #107-112
				23 => [4, 9, 3, 5, 0, 2, 26] #107-112
			}

	def index
	end

	def marathondev

		@runs_array = [ 	
			3.0, 5.0, 3.0, 0.0, 3.0, 5.0, 0.0,
			3.0, 5.0, 3.0, 0.0, 3.0, 6.0, 0.0,
			4.0, 3.8, 4.0, 0.0, 2.0, 3.0, 0.0,
			0.0, 5.0, 4.0, 0.0, 4.0, 6.0, 0.0,
			4.0, 6.0, 4.0, 0.0, 4.0, 7.0, 0.0,
			4.0, 6.0, 4.0, 0.0, 4.0, 6.0, 0.0,
			4.0, 5.0, 3.0, 0.0, 2.0, 6.2, 0.0,
			3.0, 5.0, 3.0, 0.0, 3.0, 6.2, 0.0,
			3.0, 6.0, 3.0, 0.0, 3.0, 8.0, 0.0,
			4.0, 6.0, 4.0, 0.0, 4.0, 10.0, 0.0,
			4.0, 7.0, 4.0, 0.0, 5.0, 10.0, 0.0,
			4.0, 7.0, 5.0, 0.0, 5.0, 11.0, 0.0,
			5.0, 7.0, 5.0, 0.0, 5.0, 12.0, 0.0,
			5.0, 3.3, 5.0, 0.0, 5.0, 14.0, 0.0,
			4.0, 8.0, 0.0, 4.0, 0.0, 2.0, 13.0,
			0.0, 0.0, 5.0, 0.0, 5.0, 14.0, 0.0,
			5.0, 8.0, 5.0, 0.0, 5.0, 16.0, 0.0,
			5.0, 3.3, 5.0, 0.0, 5.0, 18.0, 0.0,
			5.0, 8.0, 5.0, 0.0, 5.0, 20.0, 0.0,
			5.0, 12.0, 5.0, 0.0, 5.0, 22.0, 0.0,
			0.0, 10.0, 5.0, 0.0, 4.0, 16.0, 0.0,
			4.0, 3.3, 5.0, 0.0, 4.0, 12.0, 0.0,
			4.0, 9.0, 3.0, 5.0, 0.0, 2.0, 26 
		]

		@goal_miles = @runs_array.inject{|sum, x| sum + x}

		def km_to_mi (km)
			miles = km * 0.621371
		end

		def percent_complete_training (total_miles, goal_miles)
			@percent_complete = total_miles / goal_miles
		end

		#start_date_string = params[:start_date]
		start_date_string = "2015-05-04"
		#puts "START DATE STRING: #{start_date_string}"
		@start_date = Date.parse("#{start_date_string}")

		@todays_date = Date.today


		puts "Goal miles: #{@goal_miles}"

		def plan_position_calculator todays_date, plan_start_date, runs_array
			days_elapsed = todays_date - plan_start_date #calculate span in days
			@overall_position = days_elapsed.to_i
			@week_position = (days_elapsed.to_i / 7) + 1
			@day_position = ((days_elapsed.to_i) % 7) + 1

			puts "THIS IS THE position in the array: #{@overall_position}"
			puts "THIS IS THE week: #{@week_position}"
			puts "THIS IS THE day: #{@day_position}"

			@todays_run = @runs_array[@overall_position]
		end

		plan_position_calculator @todays_date, @start_date, @runs_array

		puts "today's run is: #{@runs_array[@overall_position]}"
		puts "tomorrow's run is: #{@runs_array[@overall_position + 1]}"
		puts "the next seven runs are: #{@runs_array[@overall_position, 7]}"

		@nextsevendays = @runs_array[@overall_position, 7].each{|run| puts "#{run} miles to go"}


		@time_now = Time.now
		@race_date = Time.new(2015,10,11)

		def time_until_race todays_date, race_date
			days_until_race = race_date - todays_date
			@days_until_longint = days_until_race / (60*60*24)
			@total_days_until_race = (@days_until_longint.to_f).ceil
			@weeks_until_race = @total_days_until_race / 7
			@remainder_days_until_race = @total_days_until_race % 7
		end

		time_until_race(@time_now, @race_date)

		# Build URL for GET request

		# current_date = Time.now.utc.iso8601[0..9]
		current_date = @todays_date.to_s
		# current_date_string = current_date.to_s
		results = "200"
		base = "https://api.nike.com/me/sport/activities?"
		access_token = "access_token=lJTUBeEeSeeLBncuWWYWKT03BRG2"
		start_date_param = "&startDate=#{@start_date}"
		end_date_param = "endDate=#{current_date}"
		count = "&count=#{results}"

		url = "#{base}#{end_date_param}#{start_date_param}&#{access_token}#{count}"
		puts url
		# => https://api.nike.com/me/sport/activities?endDate=2015-05-20&startDate=2015-05-04&access_token=lJTUBeEeSeeLBncuWWYWKT03BRG2&count=200
		data = Nokogiri::HTML(open(url))

		parsed = JSON.parse(data)

		hash = parsed["data"]

		## Write file with current data

		# newFile = File.write('./dummydata.txt', hash)
		# puts "FILE SAVED AS dummydata.txt"

		@number_of_runs = 0
		@total_kilos = 0
		@total_time = 0
		@average_pace = 0
		@total_duration = 0

	
		#chronic duration
		def cd time
			ChronicDuration.parse(time)			
		end

		# Loop through hash to get all distances

		hash.each do |activity|
			if activity["activityType"] == "RUN"
				@number_of_runs += 1
				@total_kilos += activity["metricSummary"]["distance"]
				@total_duration += cd(activity["metricSummary"]["duration"])
			end
			# @total_time += activity["metricSummary"]["duration"]
			# puts "#{activity["metricSummary"]["distance"]} + DATE: #{activity["startTime"]}"
			# puts "#{activity["metricSummary"]["duration"]}"
		end

		#time spent running

		@total_duration = @total_duration.floor
		@total_hours = (@total_duration / 3600).floor
		@total_minutes = ((@total_duration % 3600) / 60).floor
		@total_seconds = @total_duration % 60

		@total_miles = km_to_mi(@total_kilos)

		# Average pace 
		@average_pace = @total_duration / @total_miles
		@average_pace_minutes = (@average_pace / 60).floor
		@average_pace_seconds = (@average_pace % 60).floor

		#predicted marathon time
		@marathon_time = @average_pace * 26.2
		@marathon_pace_minutes = (@marathon_time / 60).floor
		@marathon_pace_seconds = (@marathon_time % 60).floor


		# LAST RUN
		# Reasoning: usually the last activity will be a run. If not, the second to last one will be.


		if hash[0]["activityType"] == "RUN"
			@last_run_distance_km = hash[0]["metricSummary"]["distance"]
			@last_run_time = hash[0]["metricSummary"]["duration"]
			@last_run_start_time = hash[0]["startTime"]
		else
			@last_run_distance_km = hash[1]["metricSummary"]["distance"]
			@last_run_time = hash[1]["metricSummary"]["duration"]
			@last_run_start_time = hash[0]["startTime"]
		end

		@last_run_distance = km_to_mi @last_run_distance_km

		#puts "LAST RUN? #{@last_run_distance_km}, duration: #{@last_run_time}"

		#LAST 7 Days of Runs

		gon.pace = []
		gon.runs = []
		gon.days = []

		hash.each do |activity|
			if activity["activityType"] == "RUN"
				distance = ((activity["metricSummary"]["distance"])*0.621371192).round(2)
				gon.runs.push(distance)
				duration = (cd(activity["metricSummary"]["duration"]).round(2) / distance) / 60
				gon.pace.push(duration.round(2))
				date = activity["startTime"][0...-10]
				gon.days.push(date)
			else
				next
			end
		end
		
		gon.runs = gon.runs.reverse
		gon.days = gon.days.reverse
		gon.pace = gon.pace.reverse

		#convert from kilometers to miles

		

		percent_complete_training(@total_miles, @goal_miles)

		# Public Shaming section
		@last_run_parsed = Date.parse(@last_run_start_time)


		# Do I need to run today?

		if @todays_run > 0
			running_required = true
			puts "today is a running day"
			if @last_run_parsed == Date.today
				puts "You ran today, good job"
				@ran_yet = true
				@miles_ran_today = @last_run_distance.round(2)
			else
				puts "Paul hasn't ran yet"
				@ran_yet = false
				@miles_ran_today = 0
			end
		else
			running_required = false
			puts "today is not a running day"
		end

		puts "miles ran today: #{@miles_ran_today}"
	end



	### ========= layout 2 ========= ###






























	def marathon

		def km_to_mi (km)
			miles = km * 0.621371
		end

		def percent_complete_training (total_miles, goal_miles)
			@percent_complete = total_miles / 667
		end

		#@greeting = greetings.shuffle[0]
		#@firstname = params[:firstname]
		#@phonenumber = params[:phonenumber]

		#start_date_string = params[:start_date]
		start_date_string = "2015-05-04"
		#puts "START DATE STRING: #{start_date_string}"
		@start_date = Date.parse("#{start_date_string}")

		@todays_date = Date.today


		def plan_position_calculator todays_date, plan_start_date
			days_elapsed = todays_date - plan_start_date #calculate span in days
			@overall_position = days_elapsed.to_i + 1 #difference in days
			@week_position = (days_elapsed.to_i / 7) + 1
			@day_position = ((days_elapsed.to_i) % 7)

			puts "THIS IS THE position on the chart: #{@overall_position}"
			puts "THIS IS THE week: #{@week_position}"
			puts "THIS IS THE day: #{@day_position}"

			@todays_run = BEGINNER[@week_position][@day_position]
		end

		plan_position_calculator @todays_date, @start_date


		@time_now = Time.now
		@race_date = Time.new(2015,10,11)

		def time_until_race todays_date, race_date
			days_until_race = race_date - todays_date
			@days_until_longint = days_until_race / (60*60*24)
			@total_days_until_race = (@days_until_longint.to_f).ceil
			@weeks_until_race = @total_days_until_race / 7
			@remainder_days_until_race = @total_days_until_race % 7
		end

		time_until_race(@time_now, @race_date)

		# Build URL for GET request

		# current_date = Time.now.utc.iso8601[0..9]
		current_date = @todays_date.to_s
		# current_date_string = current_date.to_s
		results = "200"
		base = "https://api.nike.com/me/sport/activities?"
		access_token = "access_token=lJTUBeEeSeeLBncuWWYWKT03BRG2"
		start_date_param = "&startDate=#{@start_date}"
		end_date_param = "endDate=#{current_date}"
		count = "&count=#{results}"

		url = "#{base}#{end_date_param}#{start_date_param}&#{access_token}#{count}"
		puts url
		data = Nokogiri::HTML(open(url))

		parsed = JSON.parse(data)

		hash = parsed["data"]

		## Write file with current data

		# newFile = File.write('./dummydata.txt', hash)
		# puts "FILE SAVED AS dummydata.txt"

		@number_of_runs = 0
		@total_kilos = 0
		@total_time = 0
		@average_pace = 0
		@total_duration = 0

	
		#chronic duration
		def cd time
			ChronicDuration.parse(time)			
		end

		# Loop through hash to get all distances

		hash.each do |activity|
			if activity["activityType"] == "RUN"
				@number_of_runs += 1
				@total_kilos += activity["metricSummary"]["distance"]
				@total_duration += cd(activity["metricSummary"]["duration"])
			end
			# @total_time += activity["metricSummary"]["duration"]
			# puts "#{activity["metricSummary"]["distance"]} + DATE: #{activity["startTime"]}"
			# puts "#{activity["metricSummary"]["duration"]}"
		end

		#time spent running

		@total_duration = @total_duration.floor
		@total_hours = (@total_duration / 3600).floor
		@total_minutes = ((@total_duration % 3600) / 60).floor
		@total_seconds = @total_duration % 60

		@total_miles = km_to_mi(@total_kilos)

		# Average pace 
		@average_pace = @total_duration / @total_miles
		@average_pace_minutes = (@average_pace / 60).floor
		@average_pace_seconds = (@average_pace % 60).floor

		puts "TOTAL DURATION: #{@total_duration}"
		#predicted marathon time
		@marathon_time = @average_pace * 26.2
		@marathon_pace_seconds = (@marathon_time % 60).floor
		@marathon_pace_minutes = ((@marathon_time / 60) % 60).ceil
		@marathon_pace_hours = (@marathon_time / 3600).floor
		

		# LAST RUN
		# Reasoning: usually the last activity will be a run. If not, the second to last one will be.


		if hash[0]["activityType"] == "RUN"
			@last_run_distance_km = hash[0]["metricSummary"]["distance"]
			@last_run_time = hash[0]["metricSummary"]["duration"]
			@last_run_start_time = hash[0]["startTime"][0...-10]
		else
			@last_run_distance_km = hash[1]["metricSummary"]["distance"]
			@last_run_time = hash[1]["metricSummary"]["duration"]
			@last_run_start_time = hash[0]["startTime"][0...-10]
		end

		@last_run_distance = km_to_mi @last_run_distance_km

		puts @last_run_time
		@last_run_time = cd @last_run_time

		@last_run_pace_seconds = @last_run_time / @last_run_distance
		pace_seconds = @last_run_pace_seconds % 60
		pace_minutes = (@last_run_pace_seconds / 60) % 60

		@last_run_pace_formatted = format("%02d:%02d", pace_minutes, pace_seconds)

		seconds = @last_run_time % 60
		minutes = (@last_run_time / 60) % 60
		hours = @last_run_time / (60 * 60)

		@last_run_time_formatted = format("%02d:%02d:%02d", hours, minutes, seconds) #=> "01:00:00"

		#puts "LAST RUN? #{@last_run_distance_km}, duration: #{@last_run_time}"

		#LAST 7 Days of Runs

		gon.pace = []
		gon.runs = []
		gon.days = []

		hash.each do |activity|
			if activity["activityType"] == "RUN"
				distance = ((activity["metricSummary"]["distance"])*0.621371192).round(2)
				gon.runs.push(distance)
				duration = (cd(activity["metricSummary"]["duration"]).round(2) / distance) / 60
				gon.pace.push(duration.round(2))
				date = activity["startTime"][0...-10]
				gon.days.push(date)
			else
				next
			end
		end
		
		gon.runs = gon.runs.reverse
		gon.days = gon.days.reverse
		gon.pace = gon.pace.reverse

		#convert from kilometers to miles

		

		percent_complete_training(@total_miles, BEGINNER)

		# Public Shaming section
		@last_run_parsed = Date.parse(@last_run_start_time)

		puts "LAST RUN START TIME ======================>>>>> #{@last_run_parsed}"


		# Do I need to run today?

		if @todays_run > 0
			running_required = true
			puts "today is a running day"
			if @last_run_parsed == Date.today
				puts "You ran today, good job"
				@ran_yet = true
				@miles_ran_today = @last_run_distance.round(2)
			else
				puts "Paul hasn't ran yet"
				@ran_yet = false
				@miles_ran_today = 0
			end
		else
			running_required = false
			puts "today is not a running day"
		end

	if @miles_ran_today == 0
		@miles_ran_today = "0"
	end

		puts "miles ran today: #{@miles_ran_today}"
	end

	def contact
	end
end
