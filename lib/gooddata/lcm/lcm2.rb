# encoding: UTF-8
#
# Copyright (c) 2010-2016 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'hashie'
require 'terminal-table'

require_relative 'actions/actions'
require_relative 'dsl/dsl'
require_relative 'helpers/helpers'

module GoodData
  module LCM2
    MODES = {
      test: [
        HelloWorld
      ],

      release: [
        EnsureSegments,
        CreateSegmentMasters,
        SynchronizeLdm,
        SynchronizeLabelTypes,
        SynchronizeMeta,
        SynchronizeProcesses,
        SynchronizeSchedules,
      ],

      provision: [
        EnsureUsers,
        PurgeClients,
        ProvisionClients,
        EnsureTitles,
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

    MODE_NAMES = MODES.keys

    class << self
      def get_mode_actions(mode)
        MODES[mode.to_sym] || fail("Inavlid mode specified '#{mode}', supported modes are: '#{MODE_NAMES.join(', ')}'")
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
        nil
      end

      def perform(mode, params = {})
        puts "Running GoodData::LCM2#perform('#{mode}')"

        # Symbolize all keys
        Hashie.symbolize_keys!(params)

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

          # Return result for final summary
          res
        end

        puts
        puts 'SUMMARY'
        puts

        # Print execution summary/results
        self.print_actions_result(actions, results)
      end
    end
  end
end
