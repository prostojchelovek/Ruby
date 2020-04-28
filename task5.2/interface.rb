class Interface
  def initialize
    @stations = []     #Массив станций
    @routes = []       #Массив Маршрутов
    @trains = []       #Массив поездов
    @wagons_passenger = []
    @wagons_cargo = []
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
    puts 'Введите 5, если вы хотите создать пассажирский вагон'
    puts 'Введите 6, если вы хотите создать грузовой вагон'
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
    puts 'Введите 8, если вы хотите занять место в пассажирском вагоне'
    puts 'Введите 9, если вы хоите занять объем в грузовом вагоне'
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
    if @stations.size > 1
      puts 'Имена всех созданных вами станций'
      output_station_names
      puts 'Введите имя начальной станции, для создания маршрута'
      b_name = gets.chomp.to_s
      puts 'Введите имя конечной станции, для создания маршрута'
      f_name = gets.chomp.to_s
      beginning = search_station_by_name(b_name)
      final = search_station_by_name(f_name)
      @routes.insert(-  1,Route.new(beginning,final))
    else puts 'Нужно создать больше одной станции'
    end
  end

  def create_passenger_wagon
    puts 'введите общее кол-во мест в вагоне'
    quantity = gets.chomp.to_i
    @wagons_passenger << WagonPassenger.new(quantity)
  end

  def create_cargo_wagon
    puts 'введите общий объем вагона'
    quantity = gets.chomp.to_i
    @wagons_cargo << WagonCargo.new(quantity)
  end

  def assign_route_train
    if ! @routes.empty? && ! @trains.empty?
      available_routes
      i_route = gets.chomp.to_i
      puts "Список номеров всех поездов"
      output_train_numbers
      puts "Введите номер поезда, которому хотите назначить выбранный вами маршрут"
      @trains[train_index_by_number].route(@routes[i_route - 1])
    else puts "Нет созданных маршрутов или поездов"
    end
  end

  def add_wagon_train
    if ! @trains.empty?
      puts "Список номеров всех поездов"
      output_train_numbers
      puts "Введите номер поезда, которому хотите доавить вагон"
      add_wagon_by_train_number
    else puts "Нет созданных поездов"
    end
  end

  def unhook_wagon_train
    if ! @trains.empty?
      puts "Список номеров всех поездов"
      output_train_numbers
      puts "Введите номер поезда, у которого хотите отцепить вагон"
      unhook_wagon_by_train_number
    else puts "Нет созданных поездов"
    end
  end

  def take_the_place
    puts 'список всех пассажирских вагонов'
    @wagons_passenger.each { |wagon| puts " #{wagon} - #{wagon.identifier} " }
    puts 'введите номер вагона, в котором хотите занять место'
    i_wagon = gets.chomp.to_i
    @wagons_passenger.find { |wagon| wagon.fill if wagon.identifier == i_wagon }
  end

  def occupy_volume
    puts 'список всех грузовых вагонов'
    @wagons_cargo.each { |wagon| puts " #{wagon} - #{wagon.identifier} " }
    puts 'введите номер вагона, в котором хотите занять объем'
    i_wagon = gets.chomp.to_i
    puts 'введите кол-во объема, который вы хотите занять в этом вагоне'
    places = gets.chomp.to_i
    @wagons_cargo.find { |wagon| wagon.fill(places) if wagon.identifier == i_wagon }
  end

  def output_train_numbers
    @trains.each { |train| puts train.number }
  end

  def output_station_names
    @stations.each { |station| puts station.name }
  end

  def information_about_stations
    @stations.each do |station|
      puts station.name
      station.block_station do |train|
        puts "Номер поезда:#{train.number}"
        puts "Тип:#{train.class.name}"
        puts "Кол-во вагонов: #{train.wagons.size}"
      end
    end
  end

  def information_on_trains
    @trains.each do |train|
      puts "Номер поезда #{train.number}"
        if train.is_a?(PassengerTrain)
          train.block_train do |wagon|
            puts "Номер вагона:#{wagon.identifier}"
            puts "Тип вагона:#{train.class.name}"
            puts "Кол-во свободных мест: #{wagon.free}"
            puts "Кол-во занятых мест: #{wagon.occupied}"
          end
        else
          train.block_train do |wagon|
            puts "Номер вагона:#{wagon.identifier}"
            puts "Тип вагона:#{train.class.name}"
            puts "Кол-во свободного объема: #{wagon.free}"
            puts "Кол-во занятого объема: #{wagon.occupied}"
          end
        end
    end
  end

  def available_routes
    puts "Всего доступно маршрутов #{@routes.length} . Введите число от 1 до #{@routes.length}, чтобы выбрать один из маршрутов"
  end

  def train_index_by_number
    num = gets.chomp.to_s
    i_train = @trains.index(@trains.detect { |train| train.number == num })
  end

  def add_wagon_by_train_number
    if ! @trains.empty?
      i_train = train_index_by_number
      i_wagon = 0
      if @trains[i_train].is_a?(PassengerTrain) && ! @wagons_passenger.empty?
        puts 'список всех пассажирских вагонов'
        @wagons_passenger.each { |wagon| puts " #{wagon} - #{wagon.identifier} " }
        puts 'введите номер вагона, который хотите добавить'
        i_wagon = gets.chomp.to_i
        wg = @wagons_passenger.detect { |wagon| wagon.identifier == i_wagon }
        @trains[i_train].wagons.insert(-1, wg)
        puts 'вагон успешно добавлен'
      elsif @trains[i_train].is_a?(CargoTrain) && ! @wagons_cargo.empty?
        puts 'список всех грузовых вагонов'
        @wagons_cargo.each { |wagon| puts " #{wagon} - #{wagon.identifier} " }
        puts 'введите номер вагона, который хотите добавить'
        i_wagon = gets.chomp.to_i
        wg = @wagons_cargo.detect { |wagon| wagon.identifier == i_wagon }
        @trains[i_train].wagons.insert(-1, wg)
        puts 'вагон успешно добавлен'
      else puts 'нет созданных вагонов, для этого типа поезда'
      end
    else puts "Нет созданных поездов"
    end
  end

  def unhook_wagon_by_train_number
    if ! @trains.empty?
      i_train = train_index_by_number
      puts 'Выберите номер вагона, который хотите удалить'
      @trains[i_train].wagons.each { |wagon| puts "#{wagon} - #{wagon.identifier}" }
      i_wagon = gets.chomp.to_i
      wagon = @trains[i_train].wagons.detect { |wagon| wagon.identifier == i_wagon }
      @trains[i_train].unhook(wagon)
    else puts "Нет созданных поездов"
    end
  end

  def add_station_route
    if ! @routes.empty? && ! @stations.empty?
      available_routes
      i_route = gets.chomp.to_i
      puts 'Имена всех созданных вами станций'
      output_station_names
      puts 'Введите имя станции, которую хотите добавить к маршруту'
      station_name = gets.chomp.to_s
      @routes[i_route - 1].add(search_station_by_name(station_name))
    else puts "Нет созданных маршрутов или станций"
    end
  end

  def delete_station_route
    if ! @routes.empty? && ! @stations.empty?
      available_routes
      i_route = gets.chomp.to_i
      puts 'Введите имя станции, которую хотите удалить из маршрута'
      puts 'Имена всех станций, выбранного вами маршрута'
      @routes[i_route - 1].show_stations_names
      station_name = gets.chomp.to_s
      @routes[i_route - 1].delete(search_station_by_name(station_name))
    else puts "Нет созданных маршрутов или станций"
    end
  end

  def forward_station_selected_train
    if ! @trains.empty?
      puts "Список номеров всех поездов"
      output_train_numbers
      puts "Введите номер поезда, который хотите отправить вперед на одну станцию"
      forward_by_train_number
    else puts "Нет созданных поездов"
    end
  end

  def back_station_selected_train
    if ! @trains.empty?
      puts "Список номеров всех поездов"
      output_train_numbers
      puts "Введите номер поезда, который хотите отправить вперед на одну станцию"
      back_by_train_number
    else puts "Нет созданных поездов"
    end
  end

  def view_station_and_trains
    if ! @stations.empty?
      puts 'Информация о каждом поезде, на всех станциях'
      information_about_stations
    else puts "Нет созданных станций"
    end
    if ! @trains.empty?
      puts 'Информация о каждом вагоне, на всех поездах'
      information_on_trains
    else puts "Нет созданных поездов"
    end
  end

  def object_creation
    begin
      information_about_creating_object
      age=gets.chomp.to_s
      case age
      when '1'
        begin
          create_station
          puts 'Станция создана'
        rescue
          puts 'Ошибка при создании станции, введите корректное название'
          retry
        end
      when '2'
        begin
          puts 'Маршрут создан' if create_route
        rescue
          puts 'Ошибка при создании маршрута, попробуйте еще раз'
          retry
        end
      when '3'
        begin
          create_passenger_train
          puts 'Пассажирский поезд создан'
        rescue
          puts 'Ошибка при создании пассажирского поезда, введите корректный номер'
          retry
        end
      when '4'
        begin
          create_cargo_train
          puts 'Грузовой поезд создан'
        rescue
          puts 'Ошибка при создании грузового поезда, введите корректный номер'
          retry
        end
      when '5'
        create_passenger_wagon
      when '6'
        create_cargo_wagon
      when '0' || 'стоп'
        break
      end
    end while age != '0' || age != 'стоп'
  end

  def forward_by_train_number
    begin
      @trains[train_index_by_number].forward
    rescue
      puts "Сначала назначьте маршрут этому поезду"
    end
  end

  def back_by_train_number
    begin
      @trains[train_index_by_number].back
    rescue
      puts "Сначала назначьте маршрут этому поезду"
    end
  end

  def search_station_by_name(name)
    @stations.detect { |station| station.name == name }
  end

  def change_state_object
    begin
      information_about_object_changes
      age=gets.chomp.to_s
      case age
      when '1'
        assign_route_train
      when '2'
        add_wagon_train
      when '3'
        unhook_wagon_train
      when '4'
        add_station_route
      when '5'
        delete_station_route
      when '6'
        forward_station_selected_train
      when '7'
        back_station_selected_train
      when '8'
        take_the_place
      when '9'
        occupy_volume
      when '0' || 'стоп'
        break
      end
    end while age != '0' || age != 'стоп'
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
