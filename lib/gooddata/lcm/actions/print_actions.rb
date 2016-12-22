# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative 'base_action'

module GoodData
  module LCM2
    class PrintActions < BaseAction
      DESCRIPTION = 'Print Information About Actions'

      PARAMS = {
      }

      class << self
        def call(params)
          # Check if all required parameters were passed
          BaseAction.check_params(PARAMS, params)

          results = []

          GoodData::LCM2::Dsl::Dsl::PARAMS.each_pair do |k, v|
            type = []
            v.each_pair do |k, v|
              type << v[:type]
            end

            type.compact!

            results << {
              name: k,
              params: v.keys.join("\n"),
              type: type.join("\n")
            }
          end

          # Return results
          results
        end
      end
    end
  end
end
