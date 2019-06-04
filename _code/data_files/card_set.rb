require 'yaml'
require_relative 'card_group'

class CardSet
  attr_reader :card_groups, :count

  def initialize(mtg_set, cards)
    @mtg_set = mtg_set
    @card_list = cards
    @card_groups = Array.new
    @count = 0

    initialize_card_groups
  end

  def initialize_card_groups
    if @card_list.is_a? Integer
      list = [@card_list.to_s]
    else
      list = @card_list.split(", ")
    end

    cards_in_the_set = list.uniq.map { |x| [x, list.count(x)]}.to_h

    cards_in_the_set.each do |card|
      card_group = CardGroup.new(@mtg_set, card)
      @card_groups << card_group
      @count += card_group.count
    end

  end

  def to_s
    "#{card_groups} - #{count}"
  end

end
