# encoding: UTF-8
#
# Copyright (c) 2010-2017 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative 'base_action'

module GoodData
  module LCM2
    class SynchronizeNewSegments < BaseAction
      DESCRIPTION = 'Synchronize New Segments'

      RUN_MODE = "async"

      PARAMS = define_params(self) do
      end

      class << self
        def call(params)
          # Check if all required parameters were passed
          BaseAction.check_params(PARAMS, params)

          client = params.gdc_gd_client

          domain_name = params.organization || params.domain
          domain = client.domain(domain_name) || fail("Invalid domain name specified - #{domain_name}")
          domain_segments = domain.segments

          Concurrent::Promise.zip(
            *params.segments.map do |segment_in|
              Concurrent::Promise.execute do
                segment_id = segment_in.segment_id

                segment = domain_segments.find do |ds|
                  ds.segment_id == segment_id
                end

                if segment_in.is_new
                  segment.synchronize_clients

                  {
                    segment: segment_id,
                    new: true,
                    synchronized: true
                  }
                else
                  {
                    segment: segment_id,
                    new: false,
                    synchronized: false
                  }
                end
              end
            end
          ).value!
        end
      end
    end
  end
end
