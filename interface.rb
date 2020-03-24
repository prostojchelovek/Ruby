class Interface

  def initialize
    @stations = []     #Массив станций
    @routes = []       #Массив Маршрутов
    @trains = []       #Массив поездов
  end

  def run
    menu
  end

  private

  def main_menu_view
    puts 'Главное меню'
    puts 'Введите 1, если вы хотите создать станцию, маршрут, поезд или вагон'
    puts 'Введите 2, если вы хотите произвести операции с созданными объектами'
    puts 'Введите 3, еслм вы хотите вывести текущие данные о объектах'
    puts 'Введите 0 или стоп, если хотите закончить программу'
  end

  def information_about_creating_object
    puts 'Введите 1, если вы хотите создать станцию'
    puts 'Введите 2, если вы хотите создать маршрут'
    puts 'Введите 3, если вы хотите создать пассажирский поезд'
    puts 'Введите 4, если вы хотите создать грузовой поезд'
    puts 'Введите 0 или стоп, если хотите вернуться в главное меню'
  end

  def information_about_object_changes
    puts 'Введите 1, если вы хотите назначить маршрут поезду'
    puts 'Введите 2, если вы хотите добавить вагон к поезду'
    puts 'Введите 3, если вы хотите отцепить вагон от поезда'
    puts 'Введите 4, если вы хотите добавить станцию к маршруту'
    puts 'Введите 5, если вы хотите удалить станцию от маршрута'
    puts 'Введите 6, если вы хотите переместить поезд на одну станцию вперед'
    puts 'Введите 7, если вы хотите переместить поезд на одну станцию назад'
    puts 'Введите 0 или стоп, если хотите вернуться в главное меню'
  end

  def create_station
    puts 'Введите название станции'
    station_name = gets.chomp.to_s
    @stations.insert(-1,Station.new(station_name))
  end

  def create_passenger_train
    puts 'Введите номер пассажирского поезда'
    number = gets.chomp.to_s
    @trains.insert(-1,PassengerTrain.new(number))
  end

  def create_cargo_train
    puts 'Введите номер грузового поезда'
    number = gets.chomp.to_s
    @trains.insert(-1,CargoTrain.new(number))
  end

  def create_route
    puts 'Имена всех созданных вами станций'
    output_station_names
    puts 'Введите имя начальной станции, для создания маршрута'
    b_name = gets.chomp.to_s
    puts 'Введите имя конечной станции, для создания маршрута'
    f_name = gets.chomp.to_s
    beginning = search_station_by_name(b_name)
    final = search_station_by_name(f_name)
    @routes.insert(-1,Route.new(beginning,final))
  end

  def assign_route_train
    available_routes
    i_route = gets.chomp.to_i
    puts "Список номеров всех поездов"
    output_train_numbers
    puts "Введите номер поезда, которому хотите назначить выбранный вами маршрут"
    @trains[train_index_by_number].route(@routes[i_route - 1])
  end

  def add_wagon_train
    puts "Список номеров всех поездов"
    output_train_numbers
    puts "Введите номер поезда, которому хотите доавить вагон"
    add_wagon_by_train_number
  end

  def unhook_wagon_train
    puts "Список номеров всех поездов"
    output_train_numbers
    puts "Введите номер поезда, у которого хотите отцепить вагон"
    unhook_wagon_by_train_number
  end

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
    @trains[i_train].add(WagonPassengger.new)
    @trains[i_train].add(WagonCargo.new)
  end

  def unhook_wagon_by_train_number
    i_train = train_index_by_number
    @trains[i_train].unhook
  end

  def add_station_route
    available_routes
    i_route = gets.chomp.to_i
    puts 'Имена всех созданных вами станций'
    output_station_names
    puts 'Введите имя станции, которую хотите добавить к маршруту'
    station_name = gets.chomp.to_s
    @routes[i_route - 1].add(search_station_by_name(station_name))
  end

  def delete_station_route
    available_routes
    i_route = gets.chomp.to_i
    puts 'Введите имя станции, которую хотите удалить из маршрута'
    puts 'Имена всех станций, выбранного вами маршрута'
    @routes[i_route - 1].show_stations_names
    station_name = gets.chomp.to_s
    @routes[i_route - 1].delete(search_station_by_name(station_name))
  end

  def forward_station_selected_train
    puts "Список номеров всех поездов"
    output_train_numbers
    puts "Введите номер поезда, который хотите отправить вперед на одну станцию"
    forward_by_train_number
  end

  def back_station_selected_train
    puts "Список номеров всех поездов"
    output_train_numbers
    puts "Введите номер поезда, который хотите отправить вперед на одну станцию"
    back_by_train_number
  end

  def view_station_and_trains
    puts 'Имена всех созданных вами станций'
    output_station_names
    puts 'Введите имя станции, у которой хотите просмотреть список поездов'
    station_name = gets.chomp.to_s
    puts search_station_by_name(station_name).trains
  end

  def object_creation
    begin
      information_about_creating_object
      age=gets.chomp.to_s
      case age
      when '1'
        create_station
      when '2'
        create_route
      when '3'
        create_passenger_train
      when '4'
        create_cargo_train
      when '0' || 'стоп'
        break
      end
    end while age != '0' || age != 'стоп'
  end

  def change_state_object
    begin
      information_about_object_changes
      age=gets.chomp.to_s
      case age
      when '1'
        assign_route_train if ! @routes.empty? || ! @trains.empty?
      when '2'
        add_wagon_train if ! @trains.empty?
      when '3'
        unhook_wagon_train if ! @trains.empty?
      when '4'
        add_station_route if ! @routes.empty? && ! @stations.empty?
      when '5'
        delete_station_route if ! @routes.empty? && ! @stations.empty?
      when '6'
        forward_station_selected_train
      when '7'
        back_station_selected_train
      when '0' || 'стоп'
        break
      end
    end while age != '0' || age != 'стоп'
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
    begin #Начало интерфейса
      main_menu_view
      age=gets.chomp.to_s
      case age
      when '1'
        object_creation
      when '2'
        change_state_object
      when '3'
        view_station_and_trains
      when '0' || 'стоп'
        break
      end
    end while age != '0' || age != 'стоп'
  end

end
