module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        values = instance_variable_get("@values_#{name}".to_sym)
        values ||= []
        values << value
        instance_variable_set("@values_#{name}".to_sym, values)
        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") do
        instance_variable_get("@values_#{name}".to_sym)
      end
    end
  end

  def strong_attr_accessor(name, type_class)
    var_name = "@#{name}".to_sym

    define_method(name) { instance_variable_get(var_name) }

    define_method("#{name}=".to_sym) do |value|
      raise 'Неправильный тип объекта' unless value.is_a?(type_class)
      instance_variable_set(var_name, value)
    end
  end
end
