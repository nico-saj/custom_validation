class ValidationError < StandardError
  def initialize(errors:)
    super "Validation failed with such errors: #{errors.inspect}"
  end
end
