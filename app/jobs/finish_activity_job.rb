class FinishActivityJob < ApplicationJob
  queue_as :default

  def perform(character_id, channel_id = nil, user_id = nil, options)
    bot = Discordrb::Bot.new token: Rails.application.credentials.dig(:discord, :bot_token)
    # Simulate training outcome: random factor between 0.5 and 1.5
    outcome_factor = rand(0.5..1.5)
    duration = options[:duration] || 1
    base_exp = 10 * duration + 5
    exp = (base_exp * outcome_factor).round
    extra_exp = exp - base_exp
    char = Character.find(character_id)
    char.exp += exp
    char.activity = nil
    char.save!
    extra_exp_text = extra_exp != 0 ? " (#{extra_exp > 0 ? '+' : ''}#{extra_exp})" : ""
    outcome_text =
      if outcome_factor > 1.3
        "Es war ein legendäres Training!#{extra_exp_text} 💪"
      elsif outcome_factor > 1.0
        "Das Training lief richtig gut!#{extra_exp_text} 🚀"
      elsif outcome_factor > 0.7
        "Ein solides Training liegt hinter dir.#{extra_exp_text}"
      else
        "Das Training war heute etwas zäh...#{extra_exp_text} 😅"
      end
    message = "<@#{user_id}> beendet das Training und bekommt #{exp} exp. #{outcome_text}"
    bot.send_message(channel_id, message)
  rescue => e
    puts e
  end
end
