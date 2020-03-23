class PassengerTrain < Train

  def add_wagon(wagon_passengger)
    @wagons.insert(-1,wagon_passengger) if wagon_passengger.is_a?(WagonPassengger) && stopped? #Чтобы была возможность добавлять только пассажирские вагоны
  end

  def unhook_wagon(wagon_passengger)
    @wagons.delete(wagon_passengger) if wagon_passengger.is_a?(WagonPassengger) && stopped? && ! @wagons.empty?
  end

end
