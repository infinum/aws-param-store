# frozen_string_literal: true

require 'optparse'

module AwsParamStore
  module CLI
    EC_MISSING_OPTION = 11
    NEWLINE = "\n"

    class << self
      # @param args [Array<Object>]
      # @return [void]
      def run(args)
        options = parse(args)
        validate(options)

        write(
          env_items: prepare_env_items(
            parameters: fetch_parameters(client: Aws::SSM::Client.new, options:),
            options:
          ),
          options:
        )
      end

      # @param args [Array<Object>]
      # @return [AwsParamStore::Options]
      # @raise [OptionParser::InvalidOption]
      def parse(args)
        options = AwsParamStore::Options.new
        OptionParser.new do |parser|
          options.define_options(parser)
          parser.parse!(args)
        end

        options
      end

      # @param options [AwsParamStore::Options]
      # @return [void]
      def validate(options)
        return unless options.path.nil?

        warn('Missing option: path')
        exit EC_MISSING_OPTION
      end

      # @param env_items [Array<EnvItem>]
      # @param options [AwsParamStore::Options]
      # @return [void]
      def write(env_items:, options:)
        file = File.expand_path(options.output, Dir.pwd)
        if !File.exist?(file) || (File.exist?(file) && options.force)
          File.write(file, env_items.map(&:to_line).join(NEWLINE))
        else
          puts "File #{file} exists. Skipping overwrite"
        end
      end

      # @param client [Aws::SSM::Client]
      # @param options [AwsParamStore::Options]
      # @return [void]
      def fetch_parameters(client:, options:)
        client.get_parameters_by_path(path: options.path, with_decryption: true).flat_map(&:parameters)
      end

      # @param parameters [Array<Aws::SSM::Types::Parameter>]
      # @param options [AwsParamStore::Options]
      # @return [Array<EnvItem>]
      def prepare_env_items(parameters:, options:)
        env_items = parameters.filter_map { to_env_item(parameter: _1, path: options.path) }

        return env_items.reject(&:null?) if options.skip_nulls

        env_items
      end

      # @param parameter [Aws::SSM::Types::Parameter]
      # @param path [String]
      # @return [AwsParamStore::EnvItem, NilClass]
      def to_env_item(parameter:, path:)
        return unless parameter.name

        AwsParamStore::EnvItem.new(
          name: parameter.name.sub(path, AwsParamStore::EMPTY_STRING).upcase,
          value: parameter.value
        )
      end
    end
  end
end
