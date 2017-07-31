# encoding: UTF-8
#
# Copyright (c) 2010-2017 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative '../base_type'

module GoodData
  module LCM2
    module Type
      class EnumType < BaseType
        CATEGORY = :special

        def initialize(types)
          @types = types
        end

        def check(value)
          @types.each do |type|
            return true if type.check(value)
          end

          false
        end

        def to_s
          "#{self.class.short_name}<#{@types}>"
        end
      end
    end
  end
end
