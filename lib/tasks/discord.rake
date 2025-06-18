namespace :discord do
  desc "Runs the discord bot"
  task bot: :environment do
    bot = Discordrb::Commands::CommandBot.new token: Rails.application.credentials.dig(:discord, :bot_token),
      prefix: "!", intents: %i[server_messages]

    bot.command :train do |event, args|
      message = event.message
      author = message.author
      character = Character.where(discord_user_id: author.id).first_or_create!
      if args.empty?
        return "Ihr müsst angeben, wie lange ihr trainieren wollt, z.B. `!train 10` für 10 Minuten."
      end

      begin
        duration = Integer(args)
      rescue ArgumentError
        return "Die Trainingsdauer muss eine Zahl sein, z.B. `!train 10` für 10 Minuten."
      end
      if duration <= 0
        return "Die Trainingsdauer muss größer als 0 sein."
      end
      if duration > 60
        return "Die Trainingsdauer darf maximal 60 Minuten betragen."
      end

      FinishTrainingJob.set(wait: duration.minutes).perform_later(
        character_id: character.id,
        channel_id: event.channel.id,
        user_id: author.id,
        duration: duration
      )
      "<@#{author.id}> geht für #{duration} Minuten trainieren."
    end

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
        text = "💥 #{attacker.name} greift #{target.name} an!\n"
        text += "Nach #{fight.round} Runden geht **#{fight.winner.name}** als Sieger hervor. **#{fight.loser.name}** wird niedergestreckt und in #{fight.loser.resurrection_in.ceil}s wiederbelebt.\n"
        emojis = {
          exp: "✨",
          coppers: "💰",
          level: "🆙"
        }.with_indifferent_access

        fight.rewards.each_with_index do |rewards, index|
          rewards.each do |type, amount|
            text += "#{emojis[type]} #{participants[index].name} gewinnt #{amount} #{type}\n"
          end
        end

        text += "Kampfverlauf: <#{url}>"
        text
      else
        "Ihr müsst einen Charakter angeben, den ihr angreifen wollt, z.B. `!attack @buhrmi`."
      end
    end

    bot.run
  end
end
