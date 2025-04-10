require 'sinatra'
require 'sinatra/reloader' if development?

# Глобальная переменная для хранения данных между запросами
$booking_data = {}

get '/' do
  erb :index
end

get '/haircut' do
  erb :haircut
end

post '/haircut' do
  $booking_data[:haircut_type] = params[:haircut_type]
  $booking_data[:master] = params[:master]
  
  if $booking_data[:haircut_type].nil? || $booking_data[:master].nil? || $booking_data[:master].empty?
    @message = "Пожалуйста, выберите тип стрижки и мастера!"
    erb :haircut
  else
    redirect '/booking' # Перенаправляем на форму бронирования
  end
end

get '/booking' do
  # Передаем сохраненные данные в шаблон
  @haircut_type = $booking_data[:haircut_type]
  @master = $booking_data[:master]
  erb :booking
end

post '/booking' do
  # Получаем данные из обеих форм
  booking_details = {
    name: params[:user_name],
    phone: params[:user_phone],
    date: params[:date_zap],
    haircut: $booking_data[:haircut_type],
    master: $booking_data[:master],
    timestamp: Time.now.strftime("%Y-%m-%d %H:%M")
  }

  if booking_details.values.any?(&:empty?)
    @message = "Не все поля заполнены!"
    erb :booking
  else
    # Запись в единый файл
    File.open("public/bookings.txt", "a") do |f|
      f.puts [
        "Клиент: #{booking_details[:name]}",
        "Телефон: #{booking_details[:phone]}",
        "Дата: #{booking_details[:date]}",
        "Стрижка: #{booking_details[:haircut]}",
        "Мастер: #{booking_details[:master]}",
        "Запись создана: #{booking_details[:timestamp]}",
        "------------------------------------"
      ].join("\n")
    end
    
    @message = "#{booking_details[:name]}, вы успешно записаны на #{booking_details[:date]}!"
    $booking_data = {} # Очищаем временные данные
    erb :booking
  end
end

get '/contacts' do
  erb :contacts
end