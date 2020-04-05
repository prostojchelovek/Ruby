require_relative 'company_name.rb'

class Wagon    #В будущем может увеличиться кол-во типов поездов, поэтому общие методы можно расположить в классе Wagon
  include CompanyName
end
