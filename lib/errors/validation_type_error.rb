class ValidationTypeError < StandardError
  def initialize(validation_types:)
    super "Validation type hasn't been found. Available validation types: #{validation_types}"
  end
end
