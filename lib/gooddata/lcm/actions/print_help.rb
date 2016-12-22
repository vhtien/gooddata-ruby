# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative 'base_action'

module GoodData
  module LCM2
    class PrintHelp < BaseAction
      DESCRIPTION = 'Print Help'

      PARAMS = {
      }

      class << self
        def call(params)
          # Check if all required parameters were passed
          BaseAction.check_params(PARAMS, params)

          results = []
          GoodData::LCM2::MODES.keys.each_with_index do |mode, index|
            results << {
              '#': index,
              mode: mode,
              actions: GoodData::LCM2::MODES[mode].join("\n")
            }
          end

          # Return results
          results
        end
      end
    end
  end
end
