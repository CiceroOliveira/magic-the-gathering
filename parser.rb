gem 'redcarpet'
gem 'sqlite3'

require 'redcarpet'
require 'sqlite3'
require 'tempfile'

@tempfile = Tempfile.new("page_with_cards")

begin

  db = SQLite3::Database.open "mtg_database.db"
  db.results_as_hash = true

  File.open("ravnica_allegiance_theme_sets_contents.markdown") do |input_file|
    @lines = input_file.readlines
  end

  @lines.each do |line|
    if line.start_with?("cards:") || line.start_with?("treasure:")
      line.chop!

      if line.start_with? "cards:"
        cardNumbers = line["cards:".length..-1].lstrip.split(", ")
        card_set = 'Ravnica Allegiance'
      else
        cardNumbers = line["treasure:".length..-1].lstrip.split(", ")
        card_set = 'Ravnica Allegiance Treasure'
      end

      cardNumbers.each.with_index(1) do |cardNumber, index|
        card = db.execute "SELECT CardSet, CardNumber, Name, Artist, Color, Rarity FROM Cards WHERE CardSet = ? AND CardNumber = ?", [card_set, cardNumber]


        if card.count == 0
          puts "===> #{cardNumber}"
          puts "Not Found"
        else
          card.each do |row|
            @tempfile.puts "#{index}. #{row["Name"]} (#{row["CardNumber"]})"
          end
        end

      end

    else
      @tempfile.puts line
    end
  end

@tempfile.close

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e

ensure
  db.close if db
end

data = File.read(@tempfile)

File.open("ravnica_allegiance_theme_sets_contents_final.markdown", "w") do |file|
  tempfile = File.new(@tempfile)
  tempfile.each do |markdown_line|
    file.puts markdown_line
  end
end

html = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(data)

File.write "ravnica_allegiance_theme_sets_contents.html", html
