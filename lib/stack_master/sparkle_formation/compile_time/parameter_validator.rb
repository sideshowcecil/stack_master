require_relative 'value_validator_factory'

module StackMaster
  module SparkleFormation
    module CompileTime
      class ParameterValidator

        def initialize(name, definition, parameter)
          @factory = ValueValidatorFactory.new(name, definition, parameter)
        end

        def validate
          validators = @factory.build_validators
          validators.each do |validator|
            validator.validate
            raise ArgumentError.new "Invalid compile time parameter: #{validator.error}" unless validator.is_valid
          end
        end

      end
    end
  end
end
