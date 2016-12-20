# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative 'action_base'

module GoodData
  module LCM2
    class SynchronizeMeta < Base
      PARAMS = {
      }

      class << self
        def call(params)
          # Check if all required parameters were passed
          Base.check_params(PARAMS, params)

          results = []

          # Return results
          results
        end
      end
    end
  end
end
