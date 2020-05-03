require_relative 'company_name.rb'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Train
  include CompanyName
  include InstanceCounter
  include Validation
  extend Accessors

  NUMBER_FORMAT = /^([a-z]|\d){3}-?([a-z]|\d){2}$/i

  attr_reader :wagons
  attr_accessor_with_history :speed, :number
  validate :number, :format, NUMBER_FORMAT

  @@find = {}

  def self.find(number)
    @@find[number]
  end

  def initialize(number)    #Конструктор
    @number = number
    validate!
    @speed = 0
    @wagons = []
    @@find[number] = self
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
      prev.to_send(self)           #Удаляем этот поезд с предыдущей станции
      location.accept(self)     #Добавляем этот поезд на текущую станцию
    end
  end

  def back         #Назад на одну станцию
    if prev
      @current_station_index -= 1
      following.to_send(self)             #Удаляем со следующей позиции
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

  def block_train
    wagons.each { |wagon| yield(wagon) }
  end

  protected

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
