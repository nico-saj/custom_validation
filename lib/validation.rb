module Vaildation
  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
    private

    @@validations = {}

    VALIDATION_TYPES = {
      presence: :boolean,
      format: :regexp,
      type: :class
    }.freeze

    def validate attribute_name, options
      raise AttributeNameError.new unless attribute_name.is_a?(Symbol)
      validate_options(options)
      @@validations[attribute_name] = (@@validations[attribute_name] || {}).merge(options)
    end

    def validate_options(options)
      raise ValidationTypeError.new(validation_types: VALIDATION_TYPES.keys) if (options.keys - VALIDATION_TYPES.keys).any?

      options.each do |validation_type, validation_value|
        validation = VALIDATION_TYPES[validation_type]
        case validation
        when :boolean
          raise ValidationValueError.new(validation_type: validation_type, validation: validation) unless validation_value == !!validation_value
        when :regexp
          raise ValidationValueError.new(validation_type: validation_type, validation: validation) unless validation_value.instance_of?(Regwxp)
        when :class
          raise ValidationValueError.new(validation_type: validation_type, validation: validation) unless validation_value.instance_of?(Class)
      end
    end
  end

  private

  attr_accessor :errors

  def validate!
    validate_entity
  end

  def valid?
    validate_entity
    errors.empty?
  end

  def validate_entity
    @errors = {}

    @@validations.each do |attribute_name, options|
      options.each do |validation_type, validation_value|
        unless current_valid?(attribute_name, validation_type, validation_value)
          error_msg = case validation_type
                      when :presence
                        "can't be blank"
                      when :format
                        "has to match #{validation_value.inspect}"
                      when :type
                        "has to be an instance of #{validation_value.name}"
          @errors = @errors.merge(attribute_name => (@errors[attribute_name] || []).push(error_msg))
        end
      end
    end
  end

  def current_valid?(attribute_name, validation_type, validation_value)
    case validation_type
    when :presence
      validation_value ? present?(public_send(attribute_name)) : true
    when :format
      public_send(attribute_name).match(validation_value)
    when :type
      public_send(attribute_name).instance_of?(validation_value)
  end

  def present?(value)
    !value.nil? && (value.instance_of?(String) && !value.empty? || !value.instance_of?(String))
  end
end
