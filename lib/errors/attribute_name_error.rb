require_relative 'base_error.rb'

class AttributeNameError < BaseError
  DEFAULT_MESSAGE = 'Attribute name has to be an instance of Symbol class'
end
