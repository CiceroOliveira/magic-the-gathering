require 'sqlite3'
require 'csv'

database_name = 'mtg_database.db'
current_path = File.dirname(__FILE__)

begin

  db = SQLite3::Database.open File.join(current_path, '../', database_name)

  db.execute "DROP TABLE Cards"

  db.execute "CREATE TABLE Cards(CardSet TEXT, CardNumber TEXT, Name TEXT, Artist TEXT, Color TEXT, Rarity CHAR(1), PRIMARY KEY(CardSet, CardNumber))"

  CSV.foreach(File.join(current_path, '..', 'csv_files/ravnica_allegiance_database.csv'), :headers => true) do |row|

    db.execute "INSERT INTO Cards (CardSet, CardNumber, Name, Artist, Color, Rarity) VALUES(?, ?, ?, ?, ?, ?)", [row['Set'], row['Card'], row['Name'], row['Artist'], row['Color'], row['Rarity']]
  end

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e

ensure
  db.close if db
end
