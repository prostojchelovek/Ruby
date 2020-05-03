module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
   attr_reader :validations

    def validate(*parameters) 
      @validations ||= []
      @validations << parameters[0..2]
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.find do |parametrs|
        value = instance_variable_get("@#{parametrs[0]}")
        send("validation_#{parametrs[1]}", value, parametrs[2])
      end
    end

    def validation_presence(name, additional_parameter)
      raise 'nil или пустая строка' if "#{name.to_sym}".empty?
    end

    def validation_format(name, additional_parameter)
      raise 'Неправильный формат' if  name !~ additional_parameter
    end

    def validation_type(name, additional_parameter)
      raise 'Неправильный тип переменной' if ! name.is_a?(additional_parameter)
    end

    def valid?
      validate!
      true
    rescue
      false
    end
  end
end
