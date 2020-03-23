require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Interface

  def output_train_numbers
    @trains.each { |train| puts train.number }
  end

  def output_station_names
    @stations.each { |station| puts station.name }
  end

  def available_routes
    puts "Всего доступно маршрутов #{@routes.length} . Введите число от 1 до #{@routes.length}, чтобы выбрать один из маршрутов"
  end

  def train_index_by_number
    num = gets.chomp.to_s
    i_train = @trains.index(@trains.detect { |train| train.number == num })
  end

  def add_wagon_by_train_number
    i_train = train_index_by_number
    @trains[i_train].add_wagon(WagonPassengger.new)
    @trains[i_train].add_wagon(WagonCargo.new)
  end

  def unhook_wagon_by_train_number
    i_train = train_index_by_number
    @trains[i_train].unhook_wagon(WagonPassengger.new)
    @trains[i_train].unhook_wagon(WagonCargo.new)
  end

  def forward_by_train_number
    @trains[train_index_by_number].forward
  end

  def back_by_train_number
    @trains[train_index_by_number].back
  end

  def search_station_by_name(name)
    @stations.detect { |station| station.name == name }
  end

  def menu
    @stations = []     #Массив станций
    @routes = []       #Массив Маршрутов
    @trains = []       #Массив поездов
    begin #Начало интерфеса
      puts 'Главное меню'
      puts 'Введите 1, если вы хотите создать станцию, маршрут, поезд или вагон'
      puts 'Введите 2, если вы хотите произвести операции с созданными объектами'
      puts 'Введите 3, еслм вы хотите вывести текущие данные о объектах'
      puts 'Введите 0 или стоп, если хотите закончить программу'
      age=gets.chomp.to_s
      case age
      when '1'
        begin
          puts 'Введите 1, если вы хотите создать станцию'
          puts 'Введите 2, если вы хотите создать маршрут'
          puts 'Введите 3, если вы хотите создать пассажирский поезд'
          puts 'Введите 4, если вы хотите создать грузовой поезд'
          puts 'Введите 0 или стоп, если хотите вернуться в главное меню'
          age=gets.chomp.to_s
          case age
          when '1'
            puts 'Введите название станции'
            station_name = gets.chomp.to_s
            @stations.insert(-1,Station.new(station_name))
            puts "Станция успешно создана"
          when '2'
            puts 'Имена всех созданных вами станций'
            output_station_names
            puts 'введите имя начальной станции, для создания маршрута'
            b_name = gets.chomp.to_s
            puts 'введите имя конечной станции, для создания маршрута'
            f_name = gets.chomp.to_s
            beginning = search_station_by_name(b_name)
            final = search_station_by_name(f_name)
            @routes.insert(-1,Route.new(beginning,final))
            puts "Маршрут успешно создан"
          when '3'
            puts 'Введите номер пассажирского поезда'
            number = gets.chomp.to_s
            @trains.insert(-1,PassengerTrain.new(number))
            puts "Пассажирский поезд успешно создан"
          when '4'
            puts 'Введите номер грузового поезда'
            number = gets.chomp.to_s
            @trains.insert(-1,CargoTrain.new(number))
            puts "Грузовой поезд успешно создан"
          when '0' || 'стоп'
            break
          else puts 'Введено некорректное значение'
          end
        end while age != '0' || age != 'стоп'
      when '2'
        begin
          puts 'Введите 1, если вы хотите назначить маршрут поезду'
          puts 'Введите 2, если вы хотите добавить вагон к поезду'
          puts 'Введите 3, если вы хотите отцепить вагон от поезда'
          puts 'Введите 4, если вы хотите добавить станцию к маршруту'
          puts 'Введите 5, если вы хотите удалить станцию от маршрута'
          puts 'Введите 6, если вы хотите переместить поезд на одну станцию вперед'
          puts 'Введите 7, если вы хотите переместить поезд на одну станцию назад'
          puts 'Введите 0 или стоп, если хотите вернуться в главное меню'
          age=gets.chomp.to_s
          case age
          when '1'
            if ! @routes.empty? || ! @trains.empty?
              available_routes
              i_route = gets.chomp.to_i
              puts "Список номеров всех поездов"
              output_train_numbers
              puts "Введите номер поезда, которому хотите назначить выбранный вами маршрут"
              @trains[train_index_by_number].route(@routes[i_route - 1])
              puts "Маршрут успешно назначен"
            else puts "Нет созданных поездов или маршрутов"
            end
          when '2'
            if ! @trains.empty?
              puts "Список номеров всех поездов"
              output_train_numbers
              puts "Введите номер поезда, которому хотите доавить вагон"
              add_wagon_by_train_number
              puts "Вагон успешно добавлен"
            else puts "Нет созданных поездов"
            end
          when '3'
            if ! @trains.empty?
              puts "Список номеров всех поездов"
              output_train_numbers
              puts "Введите номер поезда, у которого хотите отцепить вагон"
              unhook_wagon_by_train_number
              puts "Вагон успешно удален"
            else puts "Нет созданных поездов"
            end
          when '4'
            if ! @routes.empty? && ! @stations.empty?
              available_routes
              i_route = gets.chomp.to_i
              puts 'Имена всех созданных вами станций'
              output_station_names
              puts 'введите имя станции, которую хотите добавить к маршруту'
              station_name = gets.chomp.to_s
              @routes[i_route - 1].add(search_station_by_name(station_name))
              puts "Станция успешно добавлена"
            else puts "Нет созданных станций или маршрутов"
            end
          when '5'
            if ! @routes.empty? && ! @stations.empty?
              puts 'Имена всех созданных вами станций'
              output_station_names
              puts 'введите имя станции, которую хотите удалить из маршрута'
              station_name = gets.chomp.to_s
              available_routes
              i_route = gets.chomp.to_i
              @routes[i_route].delete(search_station_by_name(station_name))
              puts "Станция успешно удалена"
            else puts "Нет созданных станций или маршрутов"
            end
          when '6'
            puts "Список номеров всех поездов"
            output_train_numbers
            puts "Введите номер поезда, который хотите отправить вперед на одну станцию"
            forward_by_train_number
            puts "Поезд успешно отправлен вперед на одну станцию"
          when '7'
            puts "Список номеров всех поездов"
            output_train_numbers
            puts "Введите номер поезда, который хотите отправить вперед на одну станцию"
            back_by_train_number
            puts "Поезд успешно отправлен назад на одну станцию"
          when '0' || 'стоп'
            break
          end
        end while age != '0' || age != 'стоп'
      when '3'
        puts 'Имена всех созданных вами станций'
        output_station_names
        puts 'введите имя станции, у которой хотите просмотреть список поездов'
        station_name = gets.chomp.to_s
        puts search_station_by_name(station_name).trains
      when '0' || 'стоп'
        break
      else puts 'Введено некорректное значение'
      end
    end while age != '0' || age != 'стоп'
  end
end
