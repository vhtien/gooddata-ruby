# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative '../base_type'

module GoodData
  module LCM2
    module Type
      class SegmentType < BaseType
        CATEGORY = :complex

        PARAMS = define_type(self) do
          description 'Segment ID'
          param :segment_id, instance_of(Type::StringType), required: true

          description 'PID of Segment Master Project'
          param :master_pid, instance_of(Type::StringType), required: true
        end

        def check(value)
          BaseType.check_params(PARAMS, value)
        end
      end
    end
  end
end
