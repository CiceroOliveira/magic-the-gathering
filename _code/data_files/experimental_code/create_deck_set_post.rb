require 'sequel'
require 'yaml'

database_name = 'mtg_database.db'

layout = "deck_sets"
title = "Guilds of Ravnica Theme Sets"
post_title = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
post_date = "2019-02-10"
post_category = title.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
categories = "[mtg, sets, #{post_category}]"

current_path = File.dirname(__FILE__)

post = File.new("../../_posts/#{post_date}-#{post_title}.md", 'w')
post.puts '---'
post.puts "layout: #{layout}"
post.puts "title:  \"#{title}\""
post.puts "date:   #{post_date} 11:20:00 -0500"
post.puts "categories: #{categories}"
post.puts '---'

DB = Sequel.sqlite File.join(current_path, '/', database_name)

begin

  mtg = YAML.load_file("#{post_category}_contents.yml")

  ds = DB[:mtgjson_cards]

  mtg.each do |set|
    @cards = Array.new

    set["cards"].each do |card_set, cards|

      cards.lstrip.split(", ").each do |card_number|
        ds = DB[:mtgjson_cards]
        card = ds.select(:name, :rarity, :layout).where(setCode: card_set, number: card_number).all

        if card.count == 0
          puts "===> #{card_number}"
          puts "Not Found"
        else
          if card[0][:layout].eql? 'split'
            name = "#{card[0][:name]}/#{card[1][:name]}"
          else
            name = card[0][:name]
          end
          @cards << "(#{card_number}) #{name} - #{card[0][:rarity].capitalize}"
        end
      end

      set["cards"] = @cards
    end

  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e
end

mtg.each do |pack|
  post.puts '<h2>'
  post.puts "  #{pack['name']} - #{pack['pack_type']}"
  post.puts '</h2>'

  <img src="{{ site.baseurl }}/assets/img/{{ pack.image.name }}" alt="{{ pack.image.alt }}" title="{{ pack.image.title }}" class="{{ pack.pack_type | slugify}} {{ pack.image.title | slugify}}">
end

# {% for pack in site.data.ravnica_allegiance_packs %}
#   <h2>
#     {{ pack.name }} - {{ pack.pack_type }}
#   </h2>
#
#   <img src="{{ site.baseurl }}/assets/img/{{ pack.image.name }}" alt="{{ pack.image.alt }}" title="{{ pack.image.title }}" class="{{ pack.pack_type | slugify}} {{ pack.image.title | slugify}}">
#
#   <ol>
#     {% for card in pack.cards %}
#       <li>{{ card }}</li>
#     {% endfor %}
#   </ol>
# {% endfor %}
