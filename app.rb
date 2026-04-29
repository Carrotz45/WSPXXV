require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'
require 'BCrypt'

enable :sessions
set :session_secret, 'denna_hemliga_nyckel_maste_vara_superlang_minst_sextiofyra_tecken_annars_kraschar_rack_session_helt_och_hallet'

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

  p session[:user_id]

  if user_id
    new_name = params[:new_animal_name]
    new_desc = params[:new_animal_desc]
    new_age = params[:new_age]
    type_of_animal = params[:type_of_animal]
    new_price = params[:new_price]


    db.execute("INSERT INTO animals(name, description, age, type_of_animal, price) VALUES(?,?,?,?,?)", [new_name, new_desc, new_age, type_of_animal, new_price])

    animal_id = db.last_insert_row_id

    #animal_id = db.execute("SELECT id FROM animals WHERE name=?", new_name)

    db.execute("INSERT INTO animal_and_owner(user_id, animal_id) VALUES(?, ?)", [user_id, animal_id])

    redirect('/')
  else 
    redirect ('/login')
  end
  
  
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
    p "username does not exist"
    redirect('/login')
  end
  
  user_id = result.first["id"]
  password_digest = result.first["pwd_digest"]

  if BCrypt::Password.new(password_digest) == password

    session[:user_id] = user_id
    p user_id
    p session[:user_id]
    p "succsessfull login"

  else
    p "unsuccsessful wrong password"
    redirect('/login')
  end

  redirect('/')

end

post('/logout') do
  session[:user_id] = nil
  redirect('/')
end

get('/account') do
  user_id = session[:user_id]

  if user_id
    @username = db.execute('SELECT user FROM users WHERE id=?', user_id)[0]

    @user_animals = db.execute('SELECT animal_id from animal_and_owner where user_id=?', user_id)

    @animals = []

    @user_animals.each do |animal|
      animal_hash = db.execute('SELECT * FROM animals WHERE id=?', animal["animal_id"])[0]
      if animal_hash != nil
        @animals << animal_hash
      end
    end

    p @animals
  else

    redirect('/login')

  end



  slim(:account)
end

get('/account/:id/edit') do
  @animal_id = params[:id]
  slim(:edit)
end

post('/account/:id/update') do

  animal_id = params[:id]

  user_id = session[:user_id]

  p session[:user_id]

  if user_id
    new_name = params[:new_animal_name]
    new_desc = params[:new_animal_desc]
    new_age = params[:new_age]
    type_of_animal = params[:type_of_animal]
    new_price = params[:new_price]


    db.execute("UPDATE animals SET name=?, description=?, age=?, type_of_animal=?, price=? WHERE id=?",[new_name, new_desc, new_age, type_of_animal, new_price, animal_id])
    #animal_id = db.execute("SELECT id FROM animals WHERE name=?", new_name)


    redirect('/account')
  else 
    redirect ('/login')
  end


end

post('/account/:id/delete') do
  delete_this = params[:id]

  db.execute("DELETE FROM animals WHERE id=?", [delete_this])
  redirect('/account')
end



