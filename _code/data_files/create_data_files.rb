require 'sequel'
require 'yaml'

database_name = 'mtg_database.db'
current_path = File.dirname(__FILE__)

set_name = 'guilds_of_ravnica'
#set_name = 'ravnica_allegiance'

DB = Sequel.sqlite File.join(current_path, '/', database_name)

input_file = File.join(current_path, '/input_files/', "#{set_name}_theme_sets_contents.yml")
output_file = File.join(current_path, '/../../_data/', "#{set_name}_packs.yml")

begin

  packs = YAML.load_file(input_file)

  @ds = DB[:mtgjson_cards]

  packs.each do |set|
    @cards = Array.new

    set["cards"].each do |card_set, cards|
      @cards_in_set = Hash.new

      cards.lstrip.split(", ").each do |card_number|
        card = @ds.select(:name, :rarity, :layout, :types).where(setCode: card_set, number: card_number).all

        if card.count == 0
          puts "Not Found => #{card_set} - #{card_number}"
        else
          if card[0][:layout].eql? 'split'
            name = "#{card[0][:name]}/#{card[1][:name]}"
          else
            name = card[0][:name]
          end

          card_type = YAML.load(card[0][:types])[0]

          if (@cards_in_set[card_type].nil?)
            @cards_in_set[card_type] = Array.new
          end

          @cards_in_set[card_type] << {'identifier' => card_set + card_number,'card_set' => card_set, 'number' => card_number, 'name' => name, 'rarity' => card[0][:rarity].capitalize, 'types' => YAML.load(card[0][:types])[0]}

        end

      end

      @cards_in_set.each do |key, value|
        @cards_in_set[key] = value.sort_by {|h| h[:identifier] }.group_by{ |h| h }.map{|k, v| k['count']=v.size; k}
        # @cards_in_set[key] = Hash[value.group_by{ |h| [h['identifier'], h]}.map{ |k, v| [k, v.count]}]
        # value = value.uniq.map {|h| h[count: value.count(h)]; h}
        puts value
      end

      @cards_in_set.each do |key, value|
        @cards << {'type' => key, 'count' => value.sum {|h| h['count']},'cards' => value}
      end

    end

    set["cards"] = @cards

  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e
end

File.write output_file, packs.to_yaml
