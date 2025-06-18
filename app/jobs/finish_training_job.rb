class FinishTrainingJob < ApplicationJob
  queue_as :default

  def perform(character_id:, channel_id:, user_id:, duration:)
    bot = Discordrb::Bot.new token: Rails.application.credentials.dig(:discord, :bot_token)
    exp = 10 * duration # Beispiel: 10 Erfahrungspunkte pro Minute
    char = Character.find(character_id)
    char.exp += exp
    char.save!
    bot.send_message(channel_id, "<@#{user_id}> beendet sein Training und bekommt #{exp} exp.")
  rescue => e
    puts e
  end
end
