class ValidationValueError < StandardError
  def initialize(validation_types:, validation:)
    super "Validation type #{validation_type} has to have a #{validation} value"
  end
end
