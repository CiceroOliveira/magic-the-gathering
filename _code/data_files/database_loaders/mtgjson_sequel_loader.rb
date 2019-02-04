require 'json';
require 'sqlite3'
require 'sequel'

database_name = 'mtg_database.db'
current_path = File.dirname(__FILE__)

mtgjson_dir = File.join(current_path, '../', 'mtgjson4_data/')

all_sets_file = File.join(mtgjson_dir, "AllSets.json")
keywords_file = File.join(mtgjson_dir, "Keywords.json")
set_list_file = File.join(mtgjson_dir, "SetList.json")
version_file = File.join(mtgjson_dir, "version.json")

# all_sets = File.read("mtgjson4_data/AllSetsSample.json")

all_sets = File.read(all_sets_file)
@all_sets_parsed = JSON.parse(all_sets)

keywords = File.read(keywords_file)
@keywords_parsed = JSON.parse(keywords)

set_list = File.read(set_list_file)
@set_list_parsed = JSON.parse(set_list)

version = File.read(version_file)
@version_parsed = JSON.parse(version)

begin

  DB = Sequel.sqlite File.join(current_path, '../', database_name)

  DB.create_table! :mtgjson_sets do
    String :code, null: false
    String :mtgoCode
    String :name
    String :block
    String :releaseDate
    Integer :baseSetSize
    String :type
    String :boosterV3
    String :codeV3
    Boolean :isFoilOnly
    Boolean :isOnlineOnly
    String :meta
    Integer :totalSetSize
    Integer :tgcplayerGroupId
    primary_key [:code]
  end

  DB.create_table! :mtgjson_cards do
    String :setCode, null: false
    String :number, null: false
    String :uuid, null: false
    String :name, null: false
    String :names
    String :manaCost
    Float :convertedManaCost
    Float :faceConvertedManaCost
    String :colorIdentity
    String :colorIndicator
    String :colors
    String :originalType
    String :supertypes, null: false
    String :subtypes, null: false
    String :rarity, null: false
    String :originalText
    String :flavorText
    String :type, null: false
    String :types, null: false
    String :text
    String :power
    String :toughness
    String :loyalty
    String :artist, null: false
    String :borderColor, null: false
    String :duelDeck
    String :frameEffect
    String :frameVersion
    String :hand
    TrueClass :hasFoil
    TrueClass :hasNonFoil
    TrueClass :isAlternative
    TrueClass :isFoilOnly
    TrueClass :isOnlineOnly
    TrueClass :isOversized
    TrueClass :isReserved
    TrueClass :isTimeshifted
    String :layout, null: false
    String :legalities, null: false
    String :life
    Integer :multiverseId
    String :printings, null: false
    String :rulings
    String :scryfallId, null: false
    String :side
    String :starter
    Integer :tcgplayerProductId
    String :tcgplayerPurchaseUrl
    String :variations
    String :watermark
    primary_key [:setCode, :number, :uuid]
  end

  DB.create_table! :mtgjson_tokens do
    String :setCode, null: false
    String :number
    String :uuid, null: false
    String :name, null: false
    String :power
    String :toughness
    String :colorIdentity
    String :colorIndicator
    String :colors
    String :type, null: false
    String :text
    String :loyalty
    String :artist
    String :borderColor
    TrueClass :isOnlineOnly
    String :reverseRelated
    String :scryfallId, null: false
    String :side
    String :watermark
    primary_key [:setCode, :uuid]
    index [:setCode, :number, :uuid]
  end

  DB.create_table! :mtgjson_keywords do
    String :type, null: false
    String :name, null: false
    primary_key [:type, :name]
  end

  DB.create_table! :mtgjson_set_list do
    String :code, null: false
    String :name, null: false
    String :releaseDate
    primary_key [:code]
  end

  DB.create_table! :mtgjson_version do
    String :date, null: false
    String :version, null: false
    primary_key [:version]
  end

  @sets = DB[:mtgjson_sets]
  @tokens = DB[:mtgjson_tokens]
  @cards = DB[:mtgjson_cards]
  @keywords = DB[:mtgjson_keywords]
  @set_list = DB[:mtgjson_set_list]
  @version = DB[:mtgjson_version]

  def insert_set(code, set)
    @sets.insert(
      code: code,
      mtgoCode: set['mtgoCode'],
      name: set['name'],
      block: set['block'],
      releaseDate: set['releaseDate'],
      baseSetSize: set['baseSetSize'],
      type: set['type'],
      boosterV3: set['boosterV3'].to_s,
      codeV3: set['codeV3'].to_s,
      isFoilOnly: set['isFoilOnly'] == 'true' ? 1 : 0,
      isOnlineOnly: set['isOnlineOnly'] == 'true' ? 1 : 0,
      meta: set['meta'].to_s,
      totalSetSize: set['totalSetSize'],
      tgcplayerGroupId: set['tgcplayerGroupId']
    )
  end

  def insert_token(setCode, token)
    @tokens.insert(
      setCode: setCode,
      number: token['number'],
      uuid: token['uuid'],
      name: token['name'],
      power: token['power'],
      toughness: token['toughness'],
      colorIdentity: token['colorIdentity'].to_s,
      colorIndicator: token['colorIndicator'].to_s,
      colors: token['colors'].to_s,
      type: token['type'],
      text: token['text'],
      loyalty: token['loyalty'],
      artist: token['artist'],
      borderColor: token['borderColor'],
      isOnlineOnly: token['isOnlineOnly'],
      reverseRelated: token['reverseRelated'].to_s,
      scryfallId: token['scryfallId'],
      side: token['side'],
      watermark: token['watermark']
    )
  end

  def insert_card(setCode, card)
    @cards.insert(
      setCode: setCode,
      number: card['number'],
      uuid: card['uuid'],
      name: card['name'],
      names: card['names'].to_s,
      manaCost: card['manaCost'],
      convertedManaCost: card['convertedManaCost'],
      faceConvertedManaCost: card['faceConvertedManaCost'],
      colorIdentity: card['colorIdentity'].to_s,
      colorIndicator: card['colorIndicator'].to_s,
      colors: card['colors'].to_s,
      originalType: card['originalType'],
      supertypes: card['supertypes'].to_s,
      subtypes: card['subtypes'].to_s,
      rarity: card['rarity'],
      originalText: card['originalText'],
      flavorText: card['flavorText'],
      type: card['type'],
      types: card['types'].to_s,
      text: card['text'],
      power: card['power'],
      toughness: card['toughness'],
      loyalty: card['loyalty'],
      artist: card['artist'],
      borderColor: card['borderColor'],
      duelDeck: card['duelDeck'],
      frameEffect: card['frameEffect'],
      frameVersion: card['frameVersion'],
      hand: card['hand'],
      hasFoil: card['hasFoil'],
      hasNonFoil: card['hasNonFoil'],
      isAlternative: card['isAlternative'],
      isFoilOnly: card['isFoilOnly'],
      isOnlineOnly: card['isOnlineOnly'],
      isOversized: card['isOversized'],
      isReserved: card['isReserved'],
      isTimeshifted: card['isTimeshifted'],
      layout: card['layout'],
      legalities: card['legalities'].to_s,
      life: card['life'],
      multiverseId: card['multiverseId'],
      printings: card['printings'].to_s,
      rulings: card['rulings'].to_s,
      scryfallId: card['scryfallId'],
      side: card['side'],
      starter: card['starter'],
      tcgplayerProductId: card['tcgplayerProductId'],
      tcgplayerPurchaseUrl: card['tcgplayerPurchaseUrl'],
      variations: card['variations'].to_s,
      watermark: card['watermark']
    )
  end

  def insert_keyword(type, keyword)
    @keywords.insert(
      type: type,
      name: keyword
    )
  end

  def insert_set_list(set_list)
    @set_list.insert(
      code: set_list['code'],
      name: set_list['name'],
      releaseDate: set_list['releaseDate']
    )
  end

  def insert_version(date, version)
    @version.insert(
      date: date,
      version: version
    )
  end

  def load_all_sets
    @all_sets_parsed.each do |key, set|

      insert_set(key, set)

      # There are repeated uuids
      set["tokens"].uniq! { |token| [token['uuid']]}

      set["tokens"].each do |token|
        # puts "#{key} -> #{token['number']}: #{token['name']} --> #{token}"
        insert_token(key, token)
      end

      set["cards"].each do |card|
        insert_card(key, card)
      end
    end
  end

  def load_keywords
    @keywords_parsed.each do |type, keywords|
      keywords.each do |keyword|
        insert_keyword type, keyword
      end
    end
  end

  def load_set_list
    @set_list_parsed.each do |set_list|
      insert_set_list set_list
    end
  end

  def load_version
    insert_version @version_parsed['date'], @version_parsed['version']
  end

  load_all_sets
  load_keywords
  load_set_list
  load_version

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e
end
