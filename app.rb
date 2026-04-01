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

  user_id = session[:user_id]

  if user_id.nil? 
    redirect ('/login')
  end
  
  new_name = params[:new_animal_name]
  new_desc = params[:new_animal_description]
  new_age = params[:new_age]
  type_of_animal = params[:type_of_animal]
  new_price = params[:new_price]


  db.execute("INSERT INTO animals(name, description, age, type_of_animal, price) VALUES(?,?,?,?,?)", [new_name, new_desc, new_age, type_of_animal, new_price])
  animal_id = db.execute("SELECT id FROM animals WHERE name=?", new_name)

  db.execute("INSERT INTO animal_and_owner(user, animal) VALUES(?, ?)", [user_id, animal_id])

  redirect('/')
end

get('/register') do
  slim(:register) 
end

post('/register') do
  username = params["username"]
  password = params["password"]
  password_confirmation = params["confirm_password"]


  result = db.execute("SELECT id FROM users WHERE user=?", username)

  if result.empty?
    if password == password_confirmation
      password_digest = BCrypt::Password.create(password)
      p password_digest
      db.execute("INSERT INTO users(user, pwd_digest) VALUES (?,?)", [username, password_digest])
      redirect('/')
    else
      #error not matching
      p "not matcing"
      redirect('/error')
    end
  else
    #error results not filled out
    p "user exists"
    redirect('/error')
  end

end



get ('/login') do

  slim(:login)
end

post('/login') do

  username = params["username"]
  password = params["password"]

  result = db.execute("SELECT id, pwd_digest FROM users WHERE user=?", [username])
  
  if result.empty?
    #username does not exist
    redirect('/error')
  end
  
  user_id = result.first["id"]
  password_digest = result.first["pwd_digest"]

  if BCrypt::Password.new(password_digest) == password

    session[:user_id] = user_id
    p user_id
    #succsessfull login

  else
    #unsuccsessful wrong password
  end

  redirect('/')

end

get('/login') do 
  slim(:login)
end
