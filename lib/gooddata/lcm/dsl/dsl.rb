# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'json'

require_relative 'params_dsl'
require_relative 'type_dsl'

require_relative '../../helpers/global_helpers'

module GoodData
  module LCM2
    module Dsl
      module Dsl
        DEFAULT_OPTS = {
          required: false,
          default: nil
        }

        def define_params(klass, &block)
          dsl = GoodData::LCM2::Dsl::ParamsDsl.new
          dsl.instance_eval(&block)

          puts "PARAMS: #{klass.name}"
          puts JSON.pretty_generate(dsl.params)
          puts

          # Return params
          dsl.params
        end

        def define_type(klass, &block)
          dsl = GoodData::LCM2::Dsl::TypeDsl.new
          dsl.instance_eval(&block)

          puts "TYPE: #{klass.name}"
          puts JSON.pretty_generate(dsl.params)
          puts

          # Return params
          dsl.params
        end
      end
    end
  end
end
