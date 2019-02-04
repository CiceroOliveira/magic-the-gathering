require 'json';

# wanted_sets = ["2ED", "5ED"]
json = File.read("mtgjson4_data/AllSetsSample.json")

# wanted_sets = ["C13", "OC13", "DOM", "GRN", "RNA", "M19"]
# json = File.read("mtgjson4_data/AllSets.json")
#
# input_data = JSON.parse(json)
#
# File.open("mtgjson4_data/AllSetsSample_en.json", "w") do |file|
#   file.puts JSON.pretty_generate(input_data.select { |k, v| wanted_sets.include? k })
# end

require 'sqlite3'

begin

  db = SQLite3::Database.open "mtg_database.db"

  db.execute "DROP TABLE IF EXISTS mtgjson_sets"

  db.execute "CREATE TABLE mtgjson_sets(code TEXT, name TEXT, release_date TEXT, base_set_size INT, block TEXT, type TEXT, boosterV3 TEXT, codeV3 TEXT, is_foil_only INT, is_online_only INT, meta TEXT, mtgo_code TEXT, tcg_player_group_id INT, total_set_size INT, PRIMARY KEY(code))"

  db.execute "CREATE TABLE mtgjson_cards(number TEXT, name TEXT, original_text TEXT, artist TEXT, border_color TEXT, color_dentity TEXT, color_indicator TEXT, colors TEXT, converted_mana_cost FLOAT, duel_deck TEXT, face_converted_mana_cost TEXT, flavor_text TEXT, frame_effect TEXT, frame_version TEXT, PRIMARY KEY(code))"

  input_data = JSON.parse(json)

  input_data.each do |key, set|

    db.execute "INSERT INTO mtgjson_sets(code, name, release_date, base_set_size, block, type, boosterV3, codeV3, is_foil_only, is_online_only, meta, mtgo_code, tcg_player_group_id, total_set_size) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [key, set['name'], set['releaseDate'], set['baseSetSize'], set['block'], set['type'], set['boosterV3'].to_s, set['codeV3'].to_s, set['isFoilOnly'] == 'true' ? 1 : 0, set['is_online_only'] == 'true' ? 1 : 0, set['meta'].to_s, set['mtgoCode'], set['tgcplayerGroupId'], set['totalSetSize']]

    set["cards"].each do |card|
      puts card["name"]

      db.execute "INSERT INTO mtgjson_sets(code, name, release_date, base_set_size, block, type, boosterV3, codeV3, is_foil_only, is_online_only, meta, mtgo_code, tcg_player_group_id, total_set_size) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [key, card['name'], card['releaseDate'], card['baseSetSize'], card['block'], card['type'], card['boosterV3'].to_s, card['codeV3'].to_s, card['isFoilOnly'] == 'true' ? 1 : 0, card['is_online_only'] == 'true' ? 1 : 0, card['meta'].to_s, card['mtgoCode'], card['tgcplayerGroupId'], card['totalSetSize']]
    end
  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e

ensure
  db.close if db
end
