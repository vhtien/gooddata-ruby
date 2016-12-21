# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative '../dsl/dsl'
require_relative '../types/types'

module GoodData
  module LCM2
    class BaseAction
      class << self
        include Dsl::Dsl

        def check_params(specification, params)
          specification.keys.each do |param_name|
            value = params[param_name]
            if value.nil?
              if specification[param_name][:opts][:required]
                fail("Mandatory parameter '#{param_name}' not specified")
              end
            else
              type = specification[param_name][:type]
              if !type.check(value)
                fail "Parameter '#{param_name}' has invalid type, expected: #{type.class.name}"
              end
            end
          end
        end
      end
    end
  end
end
