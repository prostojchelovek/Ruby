class CargoTrain < Train

  def add_wagon(wagon_cargo)
    @wagons.insert(-1,wagon_cargo) if wagon_cargo.is_a?(WagonCargo) && stopped?
  end

  def unhook_wagon(wagon_cargo)
    @wagons.delete(wagon_cargo) if wagon_cargo.is_a?(WagonCargo) && stopped? && ! @wagons.empty?
  end

end
