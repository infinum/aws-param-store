# frozen_string_literal: true

require 'aws-sdk-ssm'

require_relative 'aws_param_store/version'
require_relative 'aws_param_store/options'
require_relative 'aws_param_store/env_item'
require_relative 'aws_param_store/cli'

module AwsParamStore
  EMPTY_STRING = ''
end
