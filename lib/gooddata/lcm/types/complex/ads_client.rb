# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative '../base_type'

module GoodData
  module LCM2
    module Type
      class AdsClientType < BaseType
        CATEGORY = :complex

        PARAMS = define_type(self) do
          description 'Username used for connecting to GD'
          param :username, instance_of(Type::StringType), required: true

          description 'Password used for connecting to GD'
          param :password, instance_of(Type::StringType), required: true
        end

        def check(value)
          true
        end
      end
    end
  end
end
