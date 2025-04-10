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

post '/booking' do

  @user_name = params[:user_name]
  @user_phone = params[:user_phone]
  @date_zap = params[:date_zap]

  @message = "Jopa"

  if @user_name == "" || @user_phone == "" || @date_zap == ""
    @message = "Не все поля заполненны!"
  else
    @message = "#{@user_name}, вы успешно записаны на #{@date_zap}!"
    f = File.open "public/user.txt", "a"
    f.write "#{@user_name}, phone: #{@user_phone}, date: #{@date_zap}\n"
    f.close
  end

  erb :booking

end