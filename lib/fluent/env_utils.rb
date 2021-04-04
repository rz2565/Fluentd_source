require 'fluent/config'

module Fluent
  module EnvUtils
    def self.convert_env_var_to_type(value, type)
      Fluent::Config.reformatted_value(type, value)
    end

    class OjOptions
      OJ_OPTIONS = {
        'bigdecimal_load': :symbol,
        'max_nesting': :integer,
        'mode': :symbol,
        'use_to_json': :bool
      }
  
      OJ_OPTIONS_ALLOWED_VALUES = {
        'bigdecimal_load': %i[bigdecimal float auto],
        'mode': %i[strict null concat json rails object custom]
      }
  
      OJ_OPTIONS_DEFAULTS = {
        'bigdecimal_load': :float,
        'mode': :concat,
        'use_to_json': true
      }

      def initialize
        @options = {}
        OJ_OPTIONS_DEFAULTS.each { |key, value| @options[key] = value }
      end

      def get_options
        OJ_OPTIONS.each do |key, type|
          env_value = ENV["FLUENT_OJ_OPTION_#{key.upcase}"]
          next if env_value.nil?

          cast_value = Fluent::EnvUtils.convert_env_var_to_type(env_value, OJ_OPTIONS[key])
          next if cast_value.nil?

          next if OJ_OPTIONS_ALLOWED_VALUES[key] && !OJ_OPTIONS_ALLOWED_VALUES[key].include?(cast_value)

          @options[key.to_sym] = cast_value
        end

        @options
      end
    end
  end
end