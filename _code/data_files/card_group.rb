require 'sequel'
require_relative 'card'

class CardGroup
  attr_reader :card, :count

  database_name = 'mtg_scryfall_database.db'
  current_path = File.dirname(__FILE__)
  DB = Sequel.sqlite File.join(current_path, '/', database_name)

  def initialize(mtg_set, cards)
    @card = card_data(mtg_set, cards[0])
    @count = cards[1]
  end

  def card_data(mtg_set, card)
    card_number = card
    ds = DB[:mtg_cards]
    data = ds.select(:name, :rarity, :layout, :type_line, :mana_cost).where(card_set: mtg_set, collector_number: card_number).all

    if data.count == 0
      puts "Not Found => #{mtg_set} - #{card_number}"
    else
      card = Card.new(mtg_set, card_number, data[0][:name], data[0][:rarity], data[0][:layout], data[0][:type_line], data[0][:mana_cost])
    end

    return card
  end

  def to_s
    "#{@card} (#{@count})"
  end

end
