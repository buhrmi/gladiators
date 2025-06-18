class FinishActivityJob < ApplicationJob
  BOT = Discordrb::Bot.new token: Rails.application.credentials.dig(:discord, :bot_token)

  queue_as :default

  def perform(character_id, channel_id = nil, user_id = nil, options)
    # Simulate training outcome: random factor between 0.5 and 1.5
    outcome_factor = rand(0.6..1.5)
    duration = options[:duration] || 1
    base_exp = 10 * duration + 5
    exp = (base_exp * outcome_factor).round
    extra_exp = exp - base_exp
    char = Character.find(character_id)
    char.exp += exp
    char.save!
    extra_exp_text = extra_exp != 0 ? " (#{extra_exp > 0 ? '+' : ''}#{extra_exp})" : ""
    outcome_text =
      if outcome_factor > 1.3
        "Es war legendär!#{extra_exp_text} 💪"
      elsif outcome_factor > 1.15
        "Es lief richtig gut!#{extra_exp_text} 🚀"
      elsif outcome_factor > 1
        "Es war solide!#{extra_exp_text} 👍"
      else
        "Es lief etwas zäh...#{extra_exp_text} 😰"
      end
    message = "<@#{user_id}> beendet das Training und bekommt #{exp} exp. #{outcome_text}"
    BOT.send_message(channel_id, message)
  rescue => e
    puts e
  end
end
