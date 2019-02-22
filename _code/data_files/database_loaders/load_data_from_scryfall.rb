require 'net/http'
require 'json'
require 'sequel'

database_name = 'mtg_scryfall_database.db'
current_path = File.dirname(__FILE__)

mtgjson_dir = File.join(current_path, '../', 'mtgjson4_data/')

all_sets_file = File.join(mtgjson_dir, "AllSets.json")
keywords_file = File.join(mtgjson_dir, "Keywords.json")
set_list_file = File.join(mtgjson_dir, "SetList.json")
version_file = File.join(mtgjson_dir, "version.json")

begin

  DB = Sequel.sqlite File.join(current_path, '../', database_name)

#   DB.create_table! :mtg_sets do
#     String :code, null: false
#     String :mtgoCode
#     String :name
#     String :block
#     String :releaseDate
#     Integer :baseSetSize
#     String :type
#     String :boosterV3
#     String :codeV3
#     Boolean :isFoilOnly
#     Boolean :isOnlineOnly
#     String :meta
#     Integer :totalSetSize
#     Integer :tgcplayerGroupId
#     primary_key [:code]
#   end
#
  DB.create_table! :mtg_cards do
    String :card_set, null: false
    String :collector_number, null: false
    String :scryfall_id, null: false
    String :lang
    String :object, null: false
    String :prints_search_uri
    String :rullings_uri
    String :uri
    String :all_parts
    String :card_faces
    String :colors
    String :color_identity
    Integer :convertedManaCost
    String :edhrec_rank
    TrueClass :foil
    TrueClass :nonfoil
    String :layout
    String :legalities
    String :loyalty
    String :mana_cost
    String :name
    String :oracle_text
    TrueClass :oversized
    String :power
    String :reserved
    String :toughness
    String :type_line
    String :rarity
    primary_key [:card_set, :collector_number, :scryfall_id]
  end
#
#   DB.create_table! :mtg_tokens do
#     String :setCode, null: false
#     String :number
#     String :uuid, null: false
#     String :name, null: false
#     String :power
#     String :toughness
#     String :colorIdentity
#     String :colorIndicator
#     String :colors
#     String :type, null: false
#     String :text
#     String :loyalty
#     String :artist
#     String :borderColor
#     TrueClass :isOnlineOnly
#     String :reverseRelated
#     String :scryfallId, null: false
#     String :side
#     String :watermark
#     primary_key [:setCode, :uuid]
#     index [:setCode, :number, :uuid]
#   end
#
#   DB.create_table! :mtg_keywords do
#     String :type, null: false
#     String :name, null: false
#     primary_key [:type, :name]
#   end
#
#   DB.create_table! :mtg_set_list do
#     String :code, null: false
#     String :name, null: false
#     String :releaseDate
#     primary_key [:code]
#   end
#
#   DB.create_table! :mtg_load_date do
#     String :date, null: false
#     primary_key [:date]
#   end
#
#   @sets = DB[:mtg_sets]
  @cards = DB[:mtg_cards]
#   @keywords = DB[:mtgjson_keywords]
#   @set_list = DB[:mtgjson_set_list]
#   @version = DB[:mtgjson_version]
#
#   def insert_set(code, set)
#     @sets.insert(
#       code: code,
#       mtgoCode: set['mtgoCode'],
#       name: set['name'],
#       block: set['block'],
#       releaseDate: set['releaseDate'],
#       baseSetSize: set['baseSetSize'],
#       type: set['type'],
#       boosterV3: set['boosterV3'].to_s,
#       codeV3: set['codeV3'].to_s,
#       isFoilOnly: set['isFoilOnly'] == 'true' ? 1 : 0,
#       isOnlineOnly: set['isOnlineOnly'] == 'true' ? 1 : 0,
#       meta: set['meta'].to_s,
#       totalSetSize: set['totalSetSize'],
#       tgcplayerGroupId: set['tgcplayerGroupId']
#     )
#   end
#
#   def insert_token(setCode, token)
#     @tokens.insert(
#       setCode: setCode,
#       number: token['number'],
#       uuid: token['uuid'],
#       name: token['name'],
#       power: token['power'],
#       toughness: token['toughness'],
#       colorIdentity: token['colorIdentity'].to_s,
#       colorIndicator: token['colorIndicator'].to_s,
#       colors: token['colors'].to_s,
#       type: token['type'],
#       text: token['text'],
#       loyalty: token['loyalty'],
#       artist: token['artist'],
#       borderColor: token['borderColor'],
#       isOnlineOnly: token['isOnlineOnly'],
#       reverseRelated: token['reverseRelated'].to_s,
#       scryfallId: token['scryfallId'],
#       side: token['side'],
#       watermark: token['watermark']
#     )
#   end
#
  def insert_card(set_code, card)
    # if card['collector_number'].eql?(256)
    #    puts "data #{JSON.pretty_generate(card)}"
    # end

    @cards.insert(
      card_set: set_code.strip,
      collector_number: card['collector_number'],
      scryfall_id: card['id'],
      name: card['name'],
      object: card['object'],
      prints_search_uri: card['prints_search_uri'],
      rullings_uri: card['rullings_uri'],
      uri: card['uri'],
      all_parts: card['all_parts'].to_s,
      card_faces: card['card_faces'].to_s,
      colors: card['colors'].to_s,
      color_identity: card['color_identity'].to_s,
      convertedManaCost: card['convertedManaCost'],
      edhrec_rank: card['edhrec_rank'],
      foil: card['foil'],
      nonfoil: card['nonfoil'],
      layout: card['layout'],
      legalities: card['legalities'],
      loyalty: card['loyalty'],
      mana_cost: card['mana_cost'],
      oracle_text: card['oracle_text'],
      oversized: card['oversized'],
      power: card['power'],
      reserved: card['reserved'],
      toughness: card['toughness'],
      type_line: card['type_line'],
      rarity: card['rarity']
    )
  end
#
#   def insert_keyword(type, keyword)
#     @keywords.insert(
#       type: type,
#       name: keyword
#     )
#   end
#
#   def insert_set_list(set_list)
#     @set_list.insert(
#       code: set_list['code'],
#       name: set_list['name'],
#       releaseDate: set_list['releaseDate']
#     )
#   end
#
#   def insert_version(date, version)
#     @version.insert(
#       date: date,
#       version: version
#     )
#   end
#
#   def load_all_sets
#     @all_sets_parsed.each do |key, set|
#
#       insert_set(key, set)
#
#       # There are repeated uuids
#       set["tokens"].uniq! { |token| [token['uuid']]}
#
#       set["tokens"].each do |token|
#         # puts "#{key} -> #{token['number']}: #{token['name']} --> #{token}"
#         insert_token(key, token)
#       end
#
#       set["cards"].each do |card|
#         insert_card(key, card)
#       end
#     end
#   end
#
#   def load_keywords
#     @keywords_parsed.each do |type, keywords|
#       keywords.each do |keyword|
#         insert_keyword type, keyword
#       end
#     end
#   end
#
#   def load_set_list
#     @set_list_parsed.each do |set_list|
#       insert_set_list set_list
#     end
#   end
#
#   def load_version
#     insert_version @version_parsed['date'], @version_parsed['version']
#   end
#
#   load_all_sets
#   load_keywords
#   load_set_list
#   load_version

  sets_to_load_into_database = %w[c13 m19 grn gk1 rna gk2]

  sets_to_load_into_database.each do |set|
    set_url = 'https://api.scryfall.com/sets/' + set

    uri = URI(set_url)

    response = JSON.parse(Net::HTTP.get(uri))
    url = response['search_uri']

    loop do
      puts url

      uri = URI(url)
      req = Net::HTTP::Get.new(url.to_s)
      response = JSON.parse(Net::HTTP.get(uri))
      card_set = response['data']

      card_set.each do |card|
        insert_card(set, card)
      end

      if response['has_more']
        url = response['next_page']
      else
        break
      end

    end
  end

rescue SQLite3::Exception => e
  puts "Exception occurred"
  puts e
end
