#==============================================================================
# ** Object
#------------------------------------------------------------------------------
# Let play with Object.
#==============================================================================
class Object
  #--------------------------------------------------------------------------
  # object.is_duplicable?
  #--------------------------------------------------------------------------
  def is_duplicable?
    return false if self.is_a?(Numeric)
    return false if self.is_a?(Symbol)
    return false if self.is_a?(TrueClass)
    return false if self.is_a?(FalseClass)
    return true
  end
  #--------------------------------------------------------------------------
  # Recursive Fonction : Duplicate Object and SubObject 
  #--------------------------------------------------------------------------
  def inst_dup
    return self if !self.is_duplicable? 
    duplicated_object = self.dup
    self.instance_variables.all? do |instance|
      duplicated_object.instance_variable_set(instance,self.instance_variable_get(instance).inst_dup)
    end
    return duplicated_object
  end
  #--------------------------------------------------------------------------
  # Be a mimic
  #--------------------------------------------------------------------------
  def mimic(object)
    object.instance_variables.all? do |instance|
      self.instance_variable_set(instance,object.instance_variable_get(instance).inst_dup)
    end
  end
  #--------------------------------------------------------------------------
  # * Object Equality
  #--------------------------------------------------------------------------
  def inst_eql?(object)
    if self.is_a?(object.class)
      self.instance_variables.all? do |instance|
        self.instance_variable_get(instance) == object.instance_variable_get(instance)
      end
    end
  end
end

#==============================================================================
# ** Array
#------------------------------------------------------------------------------
# 
#==============================================================================
class Array
  def inst_dup # Special case of inst_dup
    duplicated_object = self.dup
    self.each_with_index{|instance,id| duplicated_object[id] = instance.inst_dup}
    return duplicated_object
  end
end
#==============================================================================
# ** Hash 
#------------------------------------------------------------------------------
# 
#==============================================================================
class Hash
  def inst_dup #  Special case of inst_dup
    duplicated_object = self.dup
    self.each{|key,instance| duplicated_object[key] = instance.inst_dup}
    return duplicated_object
  end
end
