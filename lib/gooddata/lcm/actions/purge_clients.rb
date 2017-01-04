# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative 'base_action'

module GoodData
  module LCM2
    class PurgeClients < BaseAction
      DESCRIPTION = 'Purge LCM Clients'

      PARAMS = define_params(self) do
        description 'Delete Extra Clients'
        param :delete_extra, instance_of(Type::BooleanType), required: false, default: false

        description 'Physically Delete Client Projects'
        param :delete_projects, instance_of(Type::BooleanType), required: false, default: false
      end

      class << self
        def call(params)
          # Check if all required parameters were passed
          BaseAction.check_params(PARAMS, params)

          results = []

          # Return results
          results
        end
      end
    end
  end
end