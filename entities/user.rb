class User
  include Validation

  attr_accessor :first_name, :last_name, :age

  validate :first_name, presence: true, type: String, format: /[A-Z][a-z]+$/
  validate :last_name, presence: true, type: String, format: /[A-Z][a-z]+$/
  validate :age, presence: true, type: Integer
end
