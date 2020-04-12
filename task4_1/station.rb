require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  NAME_FORMAT = /^[a-z]+-?[a-z]+$/i

  @@all = []

  def self.all
    @@all
  end

  def initialize(name)       #Инизиализация конструктора
    @name = name
    validate!
    @trains = []             #Объявление массива поездов
    @@all << self
    register_instance
  end

  def accept(train)          #Принять поезд
    @trains << train
  end

  def send(train)            #Отправить поезд
    @trains.delete(train)
  end

  def show_type_trains(type) #Вывод всех поездов типа type
    @trains.find_all { |train| train.type == type }
  end

  def show_number_train_type(type) #Вывод кол-ва поездов типа type
    @trains.count { |train| train.type == type }
  end

  protected

  def validate!
    raise "Неправильный формат названия стации" if name !~ NAME_FORMAT
    raise "Такая станция уже существует" if @@all.any? { |elem| elem.name == name } 
  end
end
