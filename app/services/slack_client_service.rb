require 'slack'

class SlackClientService
  attr_reader :client,
              :input

  def initialize(input)
    @input = input
    @client = Slack::Client.new(token: ENV['app_access_token'])
  end

  def post_job_info(title, salary)
    client.chat_postMessage(channel: "#practice-jobs", text: "A Turing alum just posted a new job as a #{title} making #{salary}.", icon_emoji: ":monkey_face:")
  end
    
  def confirm_name
    user_input = []
    user_input << input["text"]
    channel = input["channel"]
    user_handler = UserInfoHandler.new(user_input.first)
    job_handler = JobInfoHandler.new(user_input.second)
    client2 = Slack::Client.new(token: ENV['bot_access_token'])
    # require "pry"; binding.pry
    # @user = User.find_by(first_name: user_input.first.split.first, last_name: user_input.first.split.last) if @user
    if user_handler.check_user? == false && user_handler.get_user_counter == nil
      response = client2.chat_postMessage(
                        channel: channel, 
                        text: "We weren't able to find your name in our list. Please try again or email Turing staff to look into this issue."
                        )
                        Rails.logger.debug(YAML.dump(response))                  

    end
    if current_user #&& current_user.input_counter == 0
      # require "pry"; binding.require "pry"; binding.pry
      # if job_handler.get_user_counter == 0
        response = client2.chat_postMessage(
                       channel: channel, 
                       text: "Hi #{current_user.name}! So, you want to add a job? What's your job title?"
                       )
        user_handler.incrementer
                         # JobInfoHandler::QUESTIONS[user_counter]
       Rails.logger.debug(YAML.dump(response))                  
    elsif @user.input_counter == 1
        #  job_handler.add_job_title
       response = client2.chat_postMessage(
       channel: channel, 
       text: "Great! What company do you work for?"
       )
       user_handler.incrementer
     elsif user_handler.get_user_counter == 2
       response = client2.chat_postMessage(
       channel: channel, 
       text: "And where is this fine company located?"
       )
       user_handler.incrementer
     elsif user_handler.get_user_counter == 3
       response = client2.chat_postMessage(
       channel: channel, 
       text: "What is your yearly salary in this job? (Again, this is all strictly confidential.)"
       )
       user_handler.incrementer
     elsif user_handler.get_user_counter == 4
       response = client2.chat_postMessage(
       channel: channel, 
       text: "Almost done. When did you start this job? If you're no longer at this job, you can provide your end date in the next question. Please enter dates like mm/dd/yyyy."
       )
       user_handler.incrementer
     elsif user_handler.get_user_counter == 5
       response = client2.chat_postMessage(
       channel: channel, 
       text: "Last question: if this is a previous job, when did you leave this job? mm/dd/yyyy" 
       )
       user_handler.incrementer
     elsif user_handler.get_user_counter == 6
       response = client2.chat_postMessage(
       channel: channel, 
       text: "Great, thanks for anonymously sharing your job data with us! Your data can now be used in the statistics to help current student, prospective students, and staff members make better decisions."
       )
       user_handler.decrementer
     else
    end
  end
end