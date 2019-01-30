gem 'sqlite3'

require 'yaml'
require 'sqlite3'

@tempfile = Tempfile.new("page_with_cards")

begin

  db = SQLite3::Database.open "mtg_database.db"
  db.results_as_hash = true

  mtg = YAML.load_file("ravnica_allegiance_theme_sets_contents.yml")

  mtg.each do |set|
    @cards = Array.new

    set["cards"].lstrip.split(", ").each do |card_number|

      card_set = 'Ravnica Allegiance'

      card = db.execute "SELECT CardSet, CardNumber, Name, Artist, Color, Rarity FROM Cards WHERE CardSet = ? AND CardNumber = ?", [card_set, card_number]

      if card.count == 0
        puts "===> #{card_number}"
        puts "Not Found"
      else
        card.each do |row|
          @cards << "#{row["Name"]} (#{row["CardNumber"]})"
        end
      end
    end

    set["cards"] = @cards

  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e

ensure
  db.close if db
end

File.write "../_data/ravnica_allegiance_packs.yml", mtg.to_yaml
