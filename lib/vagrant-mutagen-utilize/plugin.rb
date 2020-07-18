require "vagrant-mutagen-utilize/Action/UpdateConfig"
require "vagrant-mutagen-utilize/Action/CacheConfig"
require "vagrant-mutagen-utilize/Action/RemoveConfig"
require "vagrant-mutagen-utilize/Action/StartOrchestration"
require "vagrant-mutagen-utilize/Action/TerminateOrchestration"

module VagrantPlugins
  module Mutagen
    class Plugin < Vagrant.plugin('2')
      name 'Mutagen'
      description <<-DESC
        This plugin manages the ~/.ssh/config file for the host machine. An entry is
        created for the hostname attribute in the vm.config.
      DESC

      config(:mutagen) do
        require_relative 'config'
        Config
      end

      action_hook(:mutagen, :machine_action_up) do |hook|
        hook.append(Action::UpdateConfig)
        hook.append(Action::StartOrchestration)
      end

      action_hook(:mutagen, :machine_action_provision) do |hook|
        hook.before(Vagrant::Action::Builtin::Provision, Action::UpdateConfig)
        hook.before(Vagrant::Action::Builtin::Provision, Action::StartOrchestration)
      end

      action_hook(:mutagen, :machine_action_halt) do |hook|
        hook.append(Action::TerminateOrchestration)
        hook.append(Action::RemoveConfig)
      end

      action_hook(:mutagen, :machine_action_suspend) do |hook|
        hook.append(Action::TerminateOrchestration)
        hook.append(Action::RemoveConfig)
      end

      action_hook(:mutagen, :machine_action_destroy) do |hook|
        hook.prepend(Action::CacheConfig)
      end

      action_hook(:mutagen, :machine_action_destroy) do |hook|
        hook.append(Action::TerminateOrchestration)
        hook.append(Action::RemoveConfig)
      end

      action_hook(:mutagen, :machine_action_reload) do |hook|
        hook.append(Action::TerminateOrchestration)
        hook.prepend(Action::RemoveConfig)
        hook.append(Action::UpdateConfig)
        hook.append(Action::StartOrchestration)
      end

      action_hook(:mutagen, :machine_action_resume) do |hook|
        hook.append(Action::TerminateOrchestration)
        hook.prepend(Action::RemoveConfig)
        hook.append(Action::UpdateConfig)
        hook.append(Action::StartOrchestration)
      end

      command(:mutagen) do
        require_relative 'command'
        Command
      end
    end
  end
end
