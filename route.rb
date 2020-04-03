require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(beginning,final)#Передаем начальную и конечную станцию, то есть обекты Station
    @stations = [beginning,final]
    register_instance
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
