require 'sequel'
require 'yaml'

database_name = 'mtg_database.db'
current_path = File.dirname(__FILE__)

DB = Sequel.sqlite File.join(current_path, '/', database_name)

begin
  # db.results_as_hash = true

  mtg = YAML.load_file("ravnica_allegiance_theme_sets_contents.yml")

  ds = DB[:mtgjson_cards]

  mtg.each do |set|
    @cards = Array.new

    set["cards"].lstrip.split(", ").each do |card_number|

      card_set = 'RNA'

      ds = DB[:mtgjson_cards]
      card = ds.select(:name, :rarity).where(setCode: card_set, number: card_number).all
      # puts card

      if card.count == 0
        puts "===> #{card_number}"
        puts "Not Found"
      else
        card.each do |row|
          @cards << "(#{card_number}) #{row[:name]} - #{row[:rarity].capitalize}"
        end
      end
    end

    set["cards"] = @cards

  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e
end

File.write "../../_data/ravnica_allegiance_packs.yml", mtg.to_yaml
