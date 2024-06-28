# frozen_string_literal: true

module AwsParamStore
  class Options
    DEFAULT_OUTPUT_FILE = '.env'

    # @return [String]
    attr_accessor :path

    # @return [Boolean]
    attr_accessor :skip_nulls

    # @return [String]
    attr_accessor :output

    # @return [Boolean]
    attr_accessor :force

    def initialize
      self.path = nil
      self.skip_nulls = false
      self.output = DEFAULT_OUTPUT_FILE
      self.force = false
    end

    # @param parser [OptionParser]
    # @return [void]
    def define_options(parser) # rubocop:disable Metrics/MethodLength
      parser.banner = 'Usage: bin/param [options]'
      parser.separator(AwsParamStore::EMPTY_STRING)
      parser.separator('Specific options:')

      specify_path(parser)
      specify_skip_nulls(parser)
      specify_output(parser)
      specify_force(parser)

      parser.separator(AwsParamStore::EMPTY_STRING)
      parser.separator('Common options:')
      parser.on_tail('-h', '--help') do
        puts parser
        exit
      end
    end

    private

    # @param parser [OptionParser]
    # @return [void]
    def specify_path(parser)
      parser.on('-p', '--path [PATH]') do |value|
        self.path = value
      end
    end

    # @param parser [OptionParser]
    # @return [void]
    def specify_skip_nulls(parser)
      parser.on('-s', '--[no-]skip-nulls') do |value|
        self.skip_nulls = value
      end
    end

    # @param parser [OptionParser]
    # @return [void]
    def specify_output(parser)
      parser.on('-o', '--output [OUTPUT]') do |value|
        self.output = value
      end
    end

    # @param parser [OptionParser]
    # @return [void]
    def specify_force(parser)
      parser.on('-f', '--[no-]force') do |value|
        self.force = value
      end
    end
  end
end
