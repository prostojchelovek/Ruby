class Station

  attr_reader :name, :trains

  def initialize(name)       #Инизиализация конструктора
    @name = name
    @trains = []             #Объявление массива поездов
  end

  def add(train)             #Передаем объект класса Train
    @trains << train         #Добавляем объект train в массив
  end

  def delete(train)                          #Удалить поезд
    @trains.delete(train)
  end

  def show_type_trains(type)
    @trains.count { |train| train.type == type  }    #кол-во поездов типа type
    @trains.find_all { |train| train.type == type  } #Вывод ID поездов типа type
  end

end


class Route

  attr_reader :station

  def initialize(beginning,final)#Передаем начальную и конечную станцию, то есть обекты Station
    @station = []
    @station[0] = beginning      #Начальная станция
    @station[1] = final          #Коненчая
  end

  def add(station)               #Добавить станцию перед последней
    @station.insert(-2,station)
  end

  def delete(station)            #Удалить станцию, если она не является первой или последней
    if ((station != @station[0]) and (station != @station[-1]))
      @station.delete(station)
    end
  end

end


class Train

  attr_reader :speed, :quantity, :number, :type

  def initialize(number,type,quantity)    #Конструктор
    @number = number
    @type = type
    @quantity = quantity                  #Количество поездов
    @rt = 0                               #Хранит информацию о станции на которой находится поезд
    @speed = 0
  end

  def go           #Набирает скорость
    @speed = 60
  end

  def stop         #Останавливается
    @speed = 0
  end

  def add          #Добавить вагон
    if speed == 0
      @quantity += 1
    else puts 'Сначала остановите поезд '
    end
  end

  def delete       #Удаление вагона, при условии, что кол-во вагонов больше 1
    if ((speed == 0) && (@quantity > 1))
      @quantity -= 1
    else puts 'Сначала остановите поезд'
    end
  end

  def route(route) #Принимает маршрут
    @route = route
    @route.station[@rt].add(self)
  end

  def forward      #Вперед на одну станцию
    if  (@rt < @route.station.length - 1)    #Проверка на выход за пределы массива
      @rt += 1
      @route.station[@rt - 1].delete(self)   #Удаляем этот поезд с предыдущей станции
      @route.station[@rt].add(self)          #Добавляем этот поезд на текущую станцию
    end
  end

  def back         #Назад на одну станцию
    if @rt >= 1
      @rt -= 1
      @route.station[@rt + 1].delete(self)   #Удаляем с предыдущей позиции
      @route.station[@rt].add(self)          #Добавляем на текущую позицию
    end
  end

  def location     #Местоположение поезда   
    self.prev
    @route.station[@rt]
    self.next
  end

  def prev         #Возвращает предыдущую станцию
    if(@rt > 0)
      @route.station[@rt - 1]
    end
  end

  def next         #Возвращает следующую станцию
    if (@rt < @route.station.length - 1)
      @route.station[@rt + 1]
    end
  end

end
