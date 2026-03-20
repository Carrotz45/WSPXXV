require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'
require 'BCrypt'

enable :sessions

db = SQLite3::Database.new('db/databas.db')
db.results_as_hash = true


get('/') do
  
  @animals_arr = db.execute('SELECT * FROM animals')
  p "din arr: #{@animals_arr}"
  slim(:index)
end

get('/upload') do

  

  slim(:upload)
end

post('/upload') do
  new_name = params[:new_animal_name]
  new_desc = params[:new_animal_description]
  new_age = params[:new_age]
  type_of_animal = params[:type_of_animal]
  new_price = params[:new_price]

  db.execute("INSERT INTO animals(name, description, age, type_of_animal, price) VALUES(?,?,?,?,?)", [])
end
