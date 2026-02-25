require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'
require 'BCrypt'

enable :sessions


get('/') do

  db = SQLite3::Database.new('db/databas.db')
  db.results_as_hash = true
  
  @animals_arr = db.execute('SELECT * FROM animals')
  p "din arr: #{@animals_arr}"
  slim(:index)
end