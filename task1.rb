if (Gem.win_platform?)                                                # Для работы кириллицы
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

class Station
  attr_reader :name
  def initialize(name)       #Инизиализация конструктора
    @name=name
    @trains=[]               #Объявление массива поездов
  end
  def add(train)             #Передаем объект класса Train
    @trains << train         #Добавляем объект train в массив
  end
  def delete(train)                             #Удалить поезд, где в качестве аргумаента передается объект train
    @trains.delete(train)                       #Альтернативный вариант удаления по индексу -- @trains.delete_at(train)
  end
  def show_trains                               #Выводим номера поездов
    @trains.each { |train| puts train.number }  #Возможна и другая реализация, когда выводятся ID объектов -- attr_reader :trains -- пишется в начале класса
  end
  def show_f_trains
    puts @trains.reject { |train| train.type=='freight'  }    #Вывод ID грузовых поездов
    @trains.count  { |train| train.type=='freight'  }         #кол-во гр
  end
  def show_p_trains
    puts @trains.reject { |train| train.type=='passenger'  }  #Вывод ID пассажирских поездов
    @trains.count  { |train| train.type=='passenger'  }       #кол-во пс
  end
end


class Route
  attr_reader :arrstation
  def initialize(beginning,final) #Передаем начальную и конечную станцию, то есть обекты Station
    @arrstation=[]
    @arrstation[0]=beginning      #Начальная станция
    @arrstation[1]=final          #Коненчая
  end
  def add(station)                #Добавить станцию перед последней
    @arrstation.insert(-2,station)
  end
  def delete(station)             #Удалить станцию, если она не является первой или последней
    if ((station != @arrstation[0]) and (station != @arrstation[-1]))
      @arrstation.delete(station)
    end
  end
  def output                      #Вывод названий всех станций этого маршрута
    @arrstation.each { |st| puts st.name }
  end
end


class Train
  attr_reader :speed, :quantity, :number, :type
  def initialize(number,type,quantity)   #Конструктор
    @number=number
    @type=type
    @quantity=quantity                   #Количество поездов
    @rt=0                                #Хранит информацию о станции на которой находится поезд
    @speed=0
  end
  def go       #Набирает скорость
    @speed=60
  end
  def stop     #Останавливается
    @speed=0
  end
  def add      #Добавить вагон
    if speed==0
      @quantity+=1
    else puts 'Сначала остановите поезд '
    end
  end
  def delete                          #Удаление вагона, при условии, что кол-во вагонов больше 1
    if ((speed==0) && (@quantity>1))
      @quantity-=1
    else puts 'Сначала остановите поезд'
    end
  end
  def route(route)  #Принимает маршрут
    @route = route
  end
  def forward       #Вперед на одну станцию, при условии!, что маршрут для поезда уже добавлен
    begin           #Обработка исключения, на случай попытки двинуться вперед на одну станцию, не имея при этом самих станций
      if  (@rt < @route.arrstation.length - 1) #Если маршрут для поезда не объявлен, то матрица станций не инизиализирована
        @rt += 1
      end
    rescue
      puts 'Добавьте маршрут для поезда!'
    end
  end
  def back          #Назад
    if @rt > 1
      @rt-=1
    end
  end
  def location     #Местоположение поезда, при условии!, что маршрут для поезда уже добавлен
    begin          #Обработка исключения, на случай попытки вернуть местоположение(станции), не имея при этом самих станций
      if (@rt==0)
        puts @route.arrstation[@rt].name,@route.arrstation[@rt+1].name                               #Если выбрана первая станция, то предыдущей нет
      elsif (@rt==@route.arrstation.length - 1)
        puts  @route.arrstation[@rt-1].name,@route.arrstation[@rt].name                              #Если выбрана последняя станция, то следующей нет
      else
        puts @route.arrstation[@rt-1].name, @route.arrstation[@rt].name, @route.arrstation[@rt+1].name #Вывод пред,тек и след
      end
    rescue
      puts 'Добавьте маршрут для поезда!'
    end
  end
end

