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
    @trains.find_all { |train| train.type == type }
  end

  def show_number_train_type(type) #Вывод кол-ва поездов типа type
    @trains.count { |train| train.type == type }
  end

end
