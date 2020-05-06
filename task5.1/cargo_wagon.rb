class WagonCargo < Wagon
  def fill_volume(volume)
    if free >= volume
      @occupied += volume
    end
  end
end
