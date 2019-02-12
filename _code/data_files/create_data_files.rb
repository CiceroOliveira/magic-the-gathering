require 'sequel'
require 'yaml'

database_name = 'mtg_database.db'
current_path = File.dirname(__FILE__)

#set_name = 'guilds_of_ravnica'
set_name = 'ravnica_allegiance'

DB = Sequel.sqlite File.join(current_path, '/', database_name)

input_file = File.join(current_path, '/input_files/', "#{set_name}_theme_sets_contents.yml")
output_file = File.join(current_path, '/../../_data/', "#{set_name}_packs.yml")

begin

  mtg = YAML.load_file(input_file)

  ds = DB[:mtgjson_cards]

  mtg.each do |set|
    @cards = Array.new

    set["cards"].each do |card_set, cards|

      cards.lstrip.split(", ").each do |card_number|
        ds = DB[:mtgjson_cards]
        card = ds.select(:name, :rarity, :layout).where(setCode: card_set, number: card_number).all

        if card.count == 0
          puts "===> #{card_number}"
          puts "Not Found"
        else
          if card[0][:layout].eql? 'split'
            name = "#{card[0][:name]}/#{card[1][:name]}"
          else
            name = card[0][:name]
          end
          @cards << "(#{card_number}) #{name} - #{card[0][:rarity].capitalize}"
        end
      end

      set["cards"] = @cards
    end

  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e
end

File.write output_file, mtg.to_yaml
