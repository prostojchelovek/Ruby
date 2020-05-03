require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  NAME_FORMAT = /^[a-z]+-?[a-z]+$/i

  attr_reader :trains
  attr_accessor_with_history :name
  validate :name, :format, NAME_FORMAT

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

  def to_send(train)            #Отправить поезд
    @trains.delete(train)
  end

  def show_type_trains(type) #Вывод всех поездов типа type
    @trains.find_all { |train| train.type == type }
  end

  def show_number_train_type(type) #Вывод кол-ва поездов типа type
    @trains.count { |train| train.type == type }
  end

  def block_station
    trains.each { |train| yield(train) }
  end
end
