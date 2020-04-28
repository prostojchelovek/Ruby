class WagonPassenger < Wagon
  def take_place
    if free > 0
      @occupied += 1
    end
  end
end
