require_relative 'company_name.rb'
require_relative 'instance_counter'
class Train
  include CompanyName
  include InstanceCounter
  attr_reader :speed, :number, :wagons  #Предполагая, что от этого класса будут наследоваться не только грузовые и пассажрские поезда, но и другие типы поездов(новые классы), можно удалить поле type

  @@find = []

  def self.find(number)
    @@find.find_all { |train| train.number == number }
  end

  def initialize(number)    #Конструктор
    @number = number
    @speed = 0
    @wagons = []
    @@find << self
    register_instance
  end

  def increase_speed(value)   #Набирает скорость
    @speed += value
  end

  def decrease_speed(value)   #Останавливается
    if @speed >= value
      @speed -= value
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

  def add(wagon)          #Добавить вагон
    if @speed == 0
      @wagons << wagon
    end
  end

  def unhook(wagon)       #Удаление вагона, при условии, что кол-во вагонов больше 1
    if @speed == 0
      @wagons.delete(wagon)
    end
  end

  protected        #От нас не требуется выводить местположение поезда(это может быть конфиденциальная информация), но эти методы могут пригодиться наследникам

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
