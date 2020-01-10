require('sinatra')
require('sinatra/reloader')
require('./lib/train')
require('./lib/city')
require('pry')
require('pg')
also_reload('lib/**/*.rb')
DB = PG.connect({:dbname => 'train_system'})

get('/') do
  redirect to('/trains')
end

# ALBUM ROUTING:

get('/trains') do
  if params["search"]
    @trains = Train.search(params[:search])
  elsif params["sort"]
    @trains = Train.sort()
  else
    @trains = Train.all
  end
  erb(:trains)
end

get ('/trains/new') do
  erb(:new_train)
end

post ('/trains') do
  train_name = params[:train_name]
  train = Train.new({:train_name => train_name, :id => nil})
  train.save()
  redirect to('/trains')
end

get ('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  if @train != nil
    erb(:train)
  else
    erb(:train_error)
  end
end

get ('/trains/:id/edit') do
  @train = Train.find(params[:id].to_i())
  erb(:edit_train)
end

patch ('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  @train.update(params[:train_name])
  redirect to('/trains')
end

delete ('/trains/:id') do
  @train= Train.find(params[:id].to_i())
  @train.delete()
  redirect to('/trains')
end

#song routing (watch this)
# get ('/trains/:id/cities/:city_id') do
#   @city = .find(params[:song_id].to_i())
#   if @song != nil
#     erb(:song)
#   else
#     @train = Train.find(params[:id].to_i())
#     erb(:album_error)
#   end
# end

# post ('/trains/:id/cities') do
#   @train = Train.find(params[:id].to_i())
#   city = City.new({:stop_name => params[:stop_name], :departure => params[:departure], :train_id => @train.id, :id => nil})
#   city.save()
#   erb(:city)
# end

# patch ('/albums/:id/songs/:song_id') do
#   @train= Album.find(params[:id].to_i())
#   song = Song.find(params[:song_id].to_i())
#   song.update(params[:name], @album.id)
#   erb(:album)
# end
#
# delete ('/albums/:id/songs/:song_id') do
#   song = Song.find(params[:song_id].to_i())
#   song.delete
#   @album = Album.find(params[:id].to_i())
#   erb(:album)
# end

# ARTIST ROUTING:

get('/cities') do
  if params["search"]
    @city =City.search(params[:search])
  elsif params["sort"]
    @city =City.sort()
  else
    @city =City.all
  end
  erb(:cities)
end

get ('/cities/:id') do
  @city = City.find(params[:id].to_i())
  if @city != nil
    erb(:city)
  else
    erb(:train_error)
  end
end

get ('/city/new') do
  erb(:new_city)
end

post ('/cities') do
  stop_name = params[:stop_name]
  @city = City.new({:stop_name => stop_name, :departure => nil , :id => nil})
  @city.save()
  redirect to('/cities')
end

post ('/cities/:id') do
  stop_name = params[:stop_name]
  @city = City.new({:stop_name => stop_name, :departure => nil , :id => nil})
  @city.save()
  redirect to('/cities')
end


post ('/trains/:id/cities') do
  train_name = params[:train_name]
  id = params[:id]
  @city = City.find(params[:id].to_i())
  train = Train.new({:train_name => train_name, :id => id})
  train.save()
  @city.update({:train_name => train_name})
  redirect to('/cities')
end


patch ('/cities/:id') do
  @city = City.find(params[:id].to_i())
  @city.update(params[:stop_name])
  redirect to('/cities')
end

delete ('/cities/:id') do
  @city = City.find(params[:id].to_i())
  @city.delete()
  redirect to('/cities')
end
