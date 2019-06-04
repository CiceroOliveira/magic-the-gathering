require 'yaml'
require_relative 'card_set'

database_name = 'mtg_scryfall_database.db'
current_path = File.dirname(__FILE__)

# set_name = 'guilds_of_ravnica_theme_sets'
# set_name = 'ravnica_allegiance_theme_sets'
# set_name = 'm19_sample_deck_theme_sets'
# set_name = 'commander_2013_theme_sets'
#set_name = '2019_challenger_decks'
set_name = 'constructed_decks'

input_file = File.join(current_path, '/input_files/', "#{set_name}_contents.yml")
output_file = File.join(current_path, '/../../_data/', "#{set_name}_packs.yml")

packs = YAML.load_file(input_file)

def display_card_set(set)
  @cards = Array.new
  @cards_in_set = Hash.new
  @type_count = Hash.new

  cards_in_pack_count = 0

  set.each do |mtg_set, cards|

    card_set = CardSet.new(mtg_set, cards)

    card_set.card_groups.each do |card_group|
      card = card_group.card

      card_type = card.type_line.split(' — ')[0]

      if (@cards_in_set[card_type].nil?)
        @cards_in_set[card_type] = Array.new
      end

      if (@type_count[card_type].nil?)
        @type_count[card_type] = 0
      end

      @cards_in_set[card_type] << {'identifier' => card.card_identifier,'card_set' => card.card_set, 'number' => card.collector_number, 'name' => card.name, 'rarity' => card.rarity.capitalize, 'card_type' => card.type_line, 'mana_cost' => card.mana_cost, 'count' => card_group.count}
      @type_count[card_type] += card_group.count
      cards_in_pack_count += card_group.count
    end

  end

  @cards_in_set.each do |key, value|
    @cards << {'type' => key, 'count' => @type_count[key],'cards' => value}
  end

  set = @cards

  set << {'total_cards' => cards_in_pack_count}

  return set
end

packs.each do |set|
  set["cards"] = display_card_set(set["cards"])
  set["sideboard"] = display_card_set(set["sideboard"]) if set['sideboard']
end

File.write output_file, packs.to_yaml
