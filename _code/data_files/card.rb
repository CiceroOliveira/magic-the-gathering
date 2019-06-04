class Card
  attr_reader :card_identifier, :card_set, :collector_number, :name, :rarity, :layout, :type_line, :mana_cost

  def initialize(card_set, collector_number, name, rarity, layout, type_line, mana_cost)
    @card_identifier = card_set + collector_number
    @card_set = card_set
    @collector_number = collector_number
    @name = name
    @rarity = rarity
    @layout = layout
    @type_line = type_line
    @mana_cost = mana_cost
  end

  def to_s
    "#{@name} (#{@card_identifier})"
  end
end
