require 'sqlite3'

db = SQLite3::Database.new("databas.db")


def seed!(db)
  puts "Using db file: db/todos.db"
  puts "🧹 Dropping old tables..."
  drop_tables(db)
  puts "🧱 Creating tables..."
  create_tables(db)
  puts "🍎 Populating tables..."
  populate_tables(db)
  puts "✅ Done seeding the database!"
end

def drop_tables(db)
  db.execute('DROP TABLE IF EXISTS exempel')
end

def create_tables(db)
  db.execute('CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user TEXT NOT NULL, 
              pwd_digest TEXT NOT NULL)')

  db.execute('CREATE TABLE animals (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT NOT NULL,
              age INTERGER,
              type_of_animal TEXT NOT NULL,
              price INTERGER,
              user_id_of_poster INTERGER NOT NULL)')
end

animals = [
  ["Luna", "black cheerful cat", "4", "cat", "500", "1"]
  ["Felix", "orange lazy cat", "12", "cat", "450", "2"]
  ["Princess", "white american pitbull", "3", "dog", "500", "3"]
]

users = [
  ["Andreas", "kasjdkldf"]
  ["Birgitt", "dijfsoijf"]
  ["Clementine", "psdkfsdfkkpok"]
]
def populate_tables(db)

  animals.each do |animal|
    db.execute('INSERT INTO animals (name, description, age, type_of_animal, price, user_id_of_poster) VALUES (?,?,?,?,?,?)')
  db.execute('INSERT INTO exempel (name, description, state) VALUES ("Köp mjölk", "3 liter mellanmjölk, eko",false)')
  db.execute('INSERT INTO exempel (name, description, state) VALUES ("Köp julgran", "En rödgran",false)')
  db.execute('INSERT INTO exempel (name, description, state) VALUES ("Pynta gran", "Glöm inte lamporna i granen och tomten",false)')
end


seed!(db)





