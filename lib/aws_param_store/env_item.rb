# frozen_string_literal: true

module AwsParamStore
  PARAMETER_VALUE_NULL = 'null'

  EnvItem = Struct.new(:name, :value, keyword_init: true) do
    # @return [Boolean]
    def null? = value == PARAMETER_VALUE_NULL

    # @return [String]
    def to_line = "#{name}=#{value}"
  end
end
