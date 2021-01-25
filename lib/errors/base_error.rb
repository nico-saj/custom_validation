class BaseError < StandardError
  def initialize(message = self::DEFAULT_MESSAGE)
    super
  end
end
