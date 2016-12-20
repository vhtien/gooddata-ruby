# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

#########################################################
# New Architecture of Transfer Everything Functionality #
#########################################################
#
# modes = {
#   release: [
#     self.synchronize_ldm,
#     self.synchronize_label_types,
#     self.synchronize_meta, # Tag specified? If yes, transfer only tagged stuff. If not transfer all meta.
#     self.synchronize_etl, # Processes, Schedules, Additional Params
#   ],
#   provisioning: [
#     # self.ensure_titles # Handled by Provisioning Brick?
#     self.ensure_users,
#     self.purge_clients,
#     self.provision_clients, # LCM API
#     self.synchronize_label_types,
#     self.synchronize_etl # Processes, Schedules, Additional Params
#   ],
#   rollout: [ # Works on segments only, not using collect_clients
#     self.ensure_users,
#     self.synchronize_ldm,
#     self.synchronize_label_types,
#     self.synchronize_etl, # Processes, Schedules, Additional Params
#     self.synchronize_clients
#   ]
# }

require 'terminal-table'

require_relative 'actions/actions'
require_relative 'helpers/helpers'

module GoodData
  module LCM2
    MODES = {
      release: [
        SynchronizeLdm,
        SynchronizeLabelTypes,
        SynchronizeMeta,
        SynchronizeProcesses,
        SynchronizeSchedules,
      ],

      provision: [
        EnsureTitles,
        EnsureUsers,
        PurgeClients,
        ProvisionClients,
        SynchronizeLabelTypes,
        SynchronizeProcesses,
        SynchronizeSchedules,
      ],

      rollout: [
        EnsureUsers,
        SynchronizeLdm,
        SynchronizeProcesses,
        SynchronizeSchedules,
        SynchronizeClients,
      ]
    }

    class << self
      def get_mode_actions(mode)
        MODES[mode.to_sym] || fail("Inavlid mode specified '#{mode}', supported modes are: '#{MODES.keys.join(', ')}'")
      end

      def print_action_names(actions)
        puts 'Following actions will be performed'
        actions.each do |action|
          puts action.name
        end
      end

      def print_action_result(action, messages)
        title = action.name
        headings = (messages.first && messages.first.keys) || []

        rows = messages.map do |message|
          row = []
          headings.each do |heading|
            row << message[heading]
          end
          row
        end

        table = Terminal::Table.new :title => title, :headings => headings, :rows => rows
        puts table
      end

      def print_actions_result(actions, results)
        actions.each_with_index do |action, index|
          self.print_action_result(action, results[index])
          puts
        end
      end

      def perform(mode, params = {})
        puts "Running GoodData::LCM2#perform('#{mode}')"

        # Get actions for mode specified
        actions = self.get_mode_actions(mode)

        # Print name of actions to be performed for debug purposes
        self.print_action_names(actions)

        # Run actions
        results = actions.map do |action|
          puts "Performing #{action.name}"

          # Invoke action
          res = action.send(:call, params)

          # Print action result
          self.print_action_result(action, res)

          # Return result for finally summary
          res
        end

        self.print_actions_result(actions, results)
      end
    end
  end
end
