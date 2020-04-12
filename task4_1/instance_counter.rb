module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :quantity

    def instances
      @quantity
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def register_instance
      self.class.quantity ||= 0
      self.class.quantity += 1
    end
  end
end
