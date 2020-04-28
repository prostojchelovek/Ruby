require_relative 'company_name.rb'

class Wagon    #В будущем может увеличиться кол-во типов поездов, поэтому общие методы можно расположить в классе Wagon
  include CompanyName

  attr_reader :total, :occupied, :identifier

  @@id = 0

  def initialize(volume)
    @total = volume
    @occupied = 0
    @identifier = @@id
    @@id +=1
  end

  def free
    @total - @occupied
  end

  def fill(volume)
    if free >= volume
      @occupied += volume
    end
  end
end
