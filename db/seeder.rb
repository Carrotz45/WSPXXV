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
  db.execute('DROP TABLE IF EXISTS users')
  db.execute('DROP TABLE IF EXISTS animals')
  db.execute('DROP TABLE IF EXISTS animal_and_owner')


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
              price INTERGER)')

  db.execute('CREATE TABLE animal_and_owner(
              user_id INT,
              animal_id INT,
              PRIMARY KEY (user_id, animal_id),
              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
              FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE)')
end
 

def populate_tables(db)

  animals = [
    ["Luna", "black cheerful cat", "4", "cat", "500"],
    ["Felix", "orange lazy cat", "12", "cat", "450"],
    ["Princess", "white american pitbull", "3", "dog", "500"],
    ["Rory", "golden retriver", "1", "dog", "600"]
  ]

  users = [
    ["Andreas", "test_pwd1"],
    ["Birgitt", "test_pwd2"],
    ["Clementine", "test_pwd3"]
  ]

  animals.each do |animal|
    db.execute('INSERT INTO animals (name, description, age, type_of_animal, price) VALUES (?,?,?,?,?)', [animal])
  end

  users.each do |user|
    db.execute('INSERT INTO users (user, pwd_digest) VALUES (?,?)', [user])
  end

  db.execute('INSERT INTO animal_and_owner (user_id, animal_id) VALUES(1, 1)')
  db.execute('INSERT INTO animal_and_owner (user_id, animal_id) VALUES(1, 2)')
  db.execute('INSERT INTO animal_and_owner (user_id, animal_id) VALUES(2, 3)')
  db.execute('INSERT INTO animal_and_owner (user_id, animal_id) VALUES(3, 4)')

end


seed!(db)





