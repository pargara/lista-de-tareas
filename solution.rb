require 'sinatra'
require 'httparty'
require 'json'

API = 'https://crudcrud.com/api/a92773cfae0f489fa396a07e1029f278/tasks'.freeze

# Listar todos los datos
get '/' do
  response = HTTParty.get(API)
  @tasks = JSON.parse(response.body)
  erb :index
end

get '/new' do
  erb :new
end

# Crear una entrada
post '/new' do
  name = params[:name]
  done = params[:done]
  due_date = params[:due_date]

  done = done == nil ? false : true

  headers = { 'Content-Type' => 'application/json' }

  response = HTTParty.post(API, headers: headers, body: { name: name, done: done, due_date: due_date }.to_json)

  redirect '/'
end

# Ver uno en especifico
get '/:id' do
  id = params[:id]

  response = HTTParty.get("#{API}/#{id}")

  @task = JSON.parse(response.body)

  erb :edit
end

# Editar una entrada
put '/:id' do
  id = params[:id]
  name = params[:name]
  done = params[:done]
  due_date = params[:due_date]

  done = done == nil ? false : true

  headers = { 'Content-Type' => 'application/json' }

  response = HTTParty.put("#{API}/#{id}", headers: headers, body: { name: name, done: done, due_date: due_date }.to_json)

  @task = JSON.parse(response.body)['_id']
  redirect '/'
end

# Eliminar una entrada
delete '/:id' do
  id = params[:id]

  HTTParty.delete("#{API}/#{id}")

  redirect '/'
end
