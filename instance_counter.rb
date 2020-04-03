module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def instances
      @quantity ||= -1
      @quantity += 1
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances
    end
  end

end
