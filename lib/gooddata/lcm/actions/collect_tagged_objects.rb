# encoding: UTF-8
#
# Copyright (c) 2010-2017 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative 'base_action'

module GoodData
  module LCM2
    class CollectTaggedObjects < BaseAction
      DESCRIPTION = 'Collect all objects tagged with the +$PRODUCTION_TAG+ from development projects'

      RUN_MODE = "async"

      PARAMS = define_params(self) do
        description 'Client Used for Connecting to GD'
        param :gdc_gd_client, instance_of(Type::GdClientType), required: true

        description 'Tag Name'
        param :production_tag, instance_of(Type::StringType), required: false
      end

      class << self
        def call(params)
          BaseAction.check_params(PARAMS, params)

          results = Concurrent::Array.new
          return results unless params.production_tag

          development_client = params.development_client

          synchronize = params.synchronize.map do |info|
            Concurrent::Promise.execute do
              from = info.from
              from_project = development_client.projects(from) || fail("Invalid 'from' project specified - '#{from}'")

              objects = from_project.find_by_tag(params.production_tag)

              info[:transfer_uris] ||= []
              info[:transfer_uris] += objects

              results += objects.map do |uri|
                {
                  project: from,
                  transfer_uri: uri
                }
              end

              info
            end
          end

          {
            results: results,
            params: {
              synchronize: Concurrent::Promise.zip(*synchronize).value!
            }
          }
        end
      end
    end
  end
end
