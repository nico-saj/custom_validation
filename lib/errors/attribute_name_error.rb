class AttributeNameError < StandardError
  def initialize(message = 'Attribute name has to be an instance of Symbol class')
    super
  end
end
