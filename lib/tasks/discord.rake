namespace :discord do
  desc "Runs the discord bot"
  task bot: :environment do
    bot = Discordrb::Commands::CommandBot.new token: Rails.application.credentials.dig(:discord, :bot_token),
      prefix: "!", intents: %i[server_messages]

    bot.command :attack do |event, args|
      message = event.message
      author = message.author
      match = args.match('<@(\d*)>')
      attacker = Character.where(discord_user_id: author.id).first_or_create!
      if match
        target_id = match[1]
        target = Character.where(discord_user_id: target_id).first_or_create!
        participants = [ attacker, target ]
        fight = Fight.new(
          attacker: attacker,
          target: target
        )
        fight.execute!


        url = Rails.application.routes.url_helpers.fight_url(fight)
        text = "💥 #{attacker.name} kämpft gegen #{target.name}!\n"
        text += "🪦 #{fight.loser.name} stirbt und wird in #{fight.loser.resurrection_in.ceil}s wiederbelebt.\n"
        emojis = {
          exp: "✨",
          coppers: "💰",
          level: "🆙"
        }.with_indifferent_access

        fight.rewards.each_with_index do |rewards, index|
          rewards.each do |type, amount|
            text += "#{emojis[type]} #{participants[index].name} erhält #{amount} #{type}\n"
          end
        end

        text += "Kampfverlauf: #{url}"
        text
      else
        "Ihr müsst einen Charakter angeben, den ihr angreifen wollt, z.B. `!attack @buhrmi`."
      end
    end

    bot.run
  end
end
