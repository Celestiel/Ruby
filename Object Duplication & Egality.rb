#==============================================================================
# ** Object Equality and Duplication  
#------------------------------------------------------------------------------
# Utility: Recursive version of duplication and equality
# Author Celestiel
# Free of use 
#==============================================================================
class Object # /!\ This Script is a Nuke
  #--------------------------------------------------------------------------
  # Some object respond to dup and clone but raise an error when the fonction
  # is call
  #--------------------------------------------------------------------------
  def is_duplicable?
    !self.class.ancestors.any? do |k|
      [Numeric, Symbol, TrueClass, FalseClass].include?(k)
    end
  end
  #--------------------------------------------------------------------------
  # - Recursive Fonction: inst_dup => mimic => inst_dup
  # * Duplicate an object and set set all the instances of duplicated_object
  # as deplicated version of original object's instance_variable.
  #--------------------------------------------------------------------------
  def inst_dup
    return self if !self.is_duplicable?
    duplicated_object = self.dup.mimic(self)
    return duplicated_object
  end
  #--------------------------------------------------------------------------
  # * duplicate all instance_variable of arg and set them as instance_variable
  # of self
  #--------------------------------------------------------------------------
  def mimic(object)
    object.instance_variables.each do |instance|
      self.instance_variable_set(instance,object.instance_variable_get(instance).inst_dup)
    end
  end
  #--------------------------------------------------------------------------
  # - Recursive Fonction: inst_eql? => inst_eql?
  # * Egality test between two object by recusion. Two object are equal if
  # all the instance variable are equal.
  #--------------------------------------------------------------------------
  def inst_eql?(object)
    if self.is_a?(object.class)
      self.instance_variables.each do |instance|
        self.instance_variable_get(instance).inst_eql?(object.instance_variable_get(instance))
      end
    end
  end
end
#==============================================================================
# ** String
#==============================================================================
class String
  def inst_dup # Special case of inst_dup
    self.dup 
  end
end
#==============================================================================
# ** Array
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
#==============================================================================
class Hash
  def inst_dup
    duplicated_object = self.dup
    self.each{|key,instance| duplicated_object[key] = instance.inst_dup}
    return duplicated_object
  end
end
#==============================================================================
# ** Proc
#==============================================================================
class Proc
  def inst_dup
    return self
  end
end
#==============================================================================
# ** Module Eql
#------------------------------------------------------------------------------
# Include this module in a class to set == and eql? method as inst_eql?
#==============================================================================
module Eql
  def eql?(object); self.inst_eql?(object);end
  alias :== :eql?
end
