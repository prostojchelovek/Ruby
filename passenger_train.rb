class PassengerTrain < Train

  def add(wagon)
    super if wagon.is_a?(WagonPassengger)
  end

end
