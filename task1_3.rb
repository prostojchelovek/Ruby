class Station

  attr_reader :name, :trains

  def initialize(name)       #Инизиализация конструктора
    @name = name
    @trains = []             #Объявление массива поездов
  end

  def accept(train)          #Принять поезд
    @trains << train
  end

  def send(train)            #Отправить поезд
    @trains.delete(train)
  end

  def show_type_trains(type) #Вывод всех поездов типа type
    @trains.find_all { |train| train.type == type  }
  end

  def show_number_train_type(type) #Вывод кол-ва поездов типа type
    @trains.count { |train| train.type == type  }
  end

end


class Route

  attr_reader :stations

  def initialize(beginning,final)#Передаем начальную и конечную станцию, то есть обекты Station
    @stations = [beginning,final]
  end

  def add(station)               #Добавить станцию перед последней
    @stations.insert(-2,station)
  end

  def delete(station)            #Удалить станцию, если она не является первой или последней
    @stations.delete(station) unless [first_station, last_station].include?(station)
  end

  def show_stations_names        #Выводит названия всех станций по-порядку от начальной к конечной
    @stations.each { |station| puts station.name }
  end

  def first_station              #Возвращает первую станцию
    @stations[0]
  end

  def last_station               #Возвращает последнюю станцию
    @stations[-1]
  end

end


class Train

  attr_reader :speed, :quantity, :number, :type

  def initialize(number,type,quantity)    #Конструктор
    @number = number
    @type = type
    @quantity = quantity                  #Количество поездов
    @speed = 0
  end

  def increase_speed(value)   #Набирает скорость
    @speed += value
  end

  def decrease_speed(value)   #Останавливается
    if @speed >= value
      @speed -= value
    end
  end

  def add          #Добавить вагон
    if @speed == 0
      @quantity += 1
    end
  end

  def delete       #Удаление вагона, при условии, что кол-во вагонов больше 1
    if @speed == 0 && @quantity > 1
      @quantity -= 1
    end
  end

  def route(route)             #Принимает маршрут
    @current_station_index = 0 #Индекс текущей станции
    @route = route
    location.accept(self)
  end

  def forward      #Вперед на одну станцию
    if following   #Проверка на выход за пределы массива
      @current_station_index += 1
      prev.send(self)           #Удаляем этот поезд с предыдущей станции
      location.accept(self)     #Добавляем этот поезд на текущую станцию
    end
  end

  def back         #Назад на одну станцию
    if prev
      @current_station_index -= 1
      following.send(self)             #Удаляем со следующей позиции
      location.accept(self)            #Добавляем на текущую позицию
    end
  end

  def location     #Местоположение поезда
    @route.stations[@current_station_index]
  end

  def prev         #Возвращает предыдущую станцию
    if location != @route.first_station
      @route.stations[@current_station_index - 1]
    end
  end

  def following    #Возвращает следующую станцию
    if location != @route.last_station
      @route.stations[@current_station_index + 1]
    end
  end

end
