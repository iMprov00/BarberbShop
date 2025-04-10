require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/haircut'  do

  erb :haircut

end

get '/booking' do

  erb :booking

end