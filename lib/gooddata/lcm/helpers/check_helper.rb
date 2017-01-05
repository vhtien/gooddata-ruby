# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'json'

module GoodData
  module LCM2
    class Helpers
      class << self
        def check_params(specification, params)
          specification.keys.each do |param_name|
            value = params[param_name]
            type = specification[param_name][:type]

            if value.nil? && aliases = specification[param_name][:opts][:aliases]
              aliases = [aliases] unless aliases.respond_to? :each
              aliases.each do |alias_param|
                value = params[alias_param]
                if value
                  params[param_name] = value
                  break
                end
              end
            end

            if value.nil?
              if specification[param_name][:opts][:required]
                fail("Mandatory parameter '#{param_name}' of type '#{type}' is not specified")
              elsif
                params[param_name] = specification[param_name][:opts][:default]
              end
            else
              if type.class.const_get(:CATEGORY) == :complex && !value.kind_of?(Hash)
                puts JSON.pretty_generate(params)
                fail "Expected parameter '#{param_name}' to be kind of '#{type}', got '#{value.class.name}'"
              end

              if !type.check(value)
                fail "Parameter '#{param_name}' has invalid type, expected: #{type}"
              end
            end
          end
        end
      end
    end
  end
end
