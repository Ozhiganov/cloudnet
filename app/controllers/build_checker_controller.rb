class BuildCheckerController < ApplicationController
  def start
    if BuildChecker.running?
      flash[:warning] = 'Build checker already running'
    else
      pid = start_build_checker
      sleep 2 # Time for forked process to fail

      gid = Process.getpgid(pid) rescue -1
      case gid
      when -1 then flash[:error] ='Unable to start build checker. Please check logs.'
      else flash[:notice] = 'Build checker started'
      end
    end

    redirect_to admin_build_checkers_path
  end

  def stop
    if BuildChecker.running?
      Process.kill('HUP', BuildChecker.pid)
      flash[:notice] = 'Build checker stopped'
    else
      flash[:warning] = 'Build checker is not running'
    end
    redirect_to admin_build_checkers_path
  end

  private
    def start_build_checker
      ActiveRecord::Base.connection.disconnect!
      pid = fork { BuildChecker::Orchestrator.run }
      Process.detach(pid)
      ActiveRecord::Base.establish_connection(
        Rails.application.config.database_configuration[Rails.env]
      )
      pid
    end
end