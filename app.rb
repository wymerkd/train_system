require('sinatra')
require('sinatra/reloader')
require('./lib/train')
require('./lib/city')
require('pry')
require('pg')
also_reload('lib/**/*.rb')
get('/') do
end
post('/') do
end
patch('/') do
end
delete('/') do
end
