# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative '../../helpers/global_helpers'

module GoodData
  module LCM2
    module Type
      module Dsl
        DEFAULT_OPTS = {
          required: false
        }

        class Context
          def initialize
            @params = {}
          end
        end

        def define_params(klass)
          puts "Defining params for #{klass.name}"
          yield if block_given?
        end

        def param(name, type, opts = DEFAULT_OPTS)
          opts = DEFAULT_OPTS.deep_merge(opts)
          puts "Defining field #{name} - #{type}, opts: #{opts}"
        end
      end
    end
  end
end
