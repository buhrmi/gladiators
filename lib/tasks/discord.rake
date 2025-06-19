namespace :discord do
  desc "Runs the discord bot"
  task bot: :environment do
    prefix = Rails.env.production? ? "!" : "+"
    bot = Discordrb::Commands::CommandBot.new token: Rails.application.credentials.dig(:discord, :bot_token),
      prefix: prefix, intents: %i[server_messages]


    bot.command :market do |event, args|
      "<https://arena.buhrmi.de/auctions>"
    end

    # shows level, race, and hp of own character or specified by name
    bot.command :info do |event, args|
      message = event.message
      author = message.author
      character = nil
      if args && !args.strip.empty?
        # Try to find by mention or by name
        if match = args.match('<@(?<id>\\d+)>')
          character = Character.where(discord_user_id: match[:id]).first
        else
          character = Character.where("lower(name) = ?", args.strip.downcase).first
        end
        return "Charakter nicht gefunden." unless character
      else
        character = Character.where(discord_user_id: author.id).first_or_create!
      end
      info = "[**#{character.name}** (Level #{character.level} #{character.race})](<https://arena.buhrmi.de/characters/#{character.id}>)\n"
      if character.hp <= 0
        info += "💀 HP: #{character.hp.ceil} / #{character.max_hp}\n"
        resurrection_in = character.resurrection_in.ceil
        info += "Wiederbeleben in #{resurrection_in}s\n"
      else
        info += "❤️ HP: #{character.hp.ceil} / #{character.max_hp}\n"
      end
      info += "✨ EXP: #{character.exp_on_this_level} / #{character.exp_to_next_level} bis Level Up"
      info
    end

    bot.command :cancel do |event|
      message = event.message
      author = message.author
      character = Character.where(discord_user_id: author.id).first_or_create!
      if job = character.active_job
        job.destroy
        character.update active_job_id: nil
        "<@#{author.id}> hat das Training abgebrochen."
      else
        "<@#{author.id}> hat nichts zu tun."
      end
    end

    # trains for a while and gives exp
    bot.command :train do |event, args|
      message = event.message
      author = message.author
      character = Character.where(discord_user_id: author.id).first_or_create!
      duration = 0
      if character.hp <= 0
        return "<@#{author.id}> ist tot und kann nicht trainieren. Bitte wartet noch #{character.resurrection_in.ceil} Sekunden."
      end
      character.with_lock do
        if job = character.active_job
          finish_time = job.scheduled_at
          remaining_time = finish_time - Time.now
          in_words = ActiveSupport::Duration.build(remaining_time.ceil).inspect
          return "<@#{author.id}> ist noch #{in_words} beschäftigt."
        end

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

        job = FinishActivityJob.set(wait: duration.minutes).perform_later(
          character.id,
          event.channel.id,
          author.id,
          activity: "train",
          duration: duration
        )

        character.update active_job_id: job.job_id
      end
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

        begin
          fight.execute!
        rescue Errors::GameError => e
          event.respond e.message, false, nil, nil, nil, event.message
          return nil
        end


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
