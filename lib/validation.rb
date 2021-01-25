module Validation
  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
    private

    def self.validations
      @validations ||= {}
    end

    VALIDATION_TYPES = {
      presence: :boolean,
      format: :regexp,
      type: :class
    }.freeze

    def validate attribute_name, options
      raise AttributeNameError.new unless attribute_name.is_a?(Symbol)
      validate_options(options)

      ClassMethods.validations[attribute_name] = (ClassMethods.validations[attribute_name] || {}).merge(options)
    end

    def validate_options(options)
      if (options.keys - VALIDATION_TYPES.keys).any?
        raise ValidationTypeError.new(validation_types: VALIDATION_TYPES.keys)
      end

      options.each do |validation_type, validation_value|
        validation = VALIDATION_TYPES[validation_type]
        valid = case validation
        when :boolean then validation_value == !!validation_value
        when :regexp then validation_value.instance_of?(Regexp)
        when :class then validation_value.instance_of?(Class)
        end

        raise ValidationValueError.new(validation_type: validation_type, validation: validation) unless valid
      end
    end
  end

  attr_reader :errors

  def validate!
    validate_entity
    raise ValidationError.new(errors: errors) if errors.any?
  end

  def valid?
    validate_entity
    errors.empty?
  end

  private

  def validate_entity
    @errors = {}

    ClassMethods.validations.each do |attribute_name, options|
      options.each do |validation_type, validation_value|
        unless current_valid?(attribute_name, validation_type, validation_value)
          error_msg = case validation_type
                      when :presence then "can't be blank"
                      when :format then "has to match #{validation_value.inspect}"
                      when :type then "has to be an instance of #{validation_value.name}"
                      end
          @errors = @errors.merge(attribute_name => (@errors[attribute_name] || []).push(error_msg))
        end
      end
    end
  end

  def current_valid?(attribute_name, validation_type, validation_value)
    case validation_type
    when :presence then validation_value ? present?(public_send(attribute_name)) : true
    when :format then public_send(attribute_name)&.match?(validation_value)
    when :type then public_send(attribute_name).instance_of?(validation_value)
    end
  end

  def present?(value)
    !value.nil? && (value.instance_of?(String) && !value.empty? || !value.instance_of?(String))
  end
end
