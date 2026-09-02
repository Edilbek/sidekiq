module Sidekiq
  ##
  # A Notification is a runtime event of unspecified severity.
  # Generally these should be treated as warnings that something is wrong
  # and needs remediation, with devops work or application code tuning.
  #
  # Examples:
  #  - `sidekiq.redis.slow_rtt` means the round-trip to Redis has been detected
  #    as consistently terrible. This can mean a saturated CPU, terrible network
  #    conditions or an overloaded Redis, it's impossible for Sidekiq to know.
  #  - `sidekiq.redis.down` The network connection between the Sidekiq process
  #    and Redis has dropped.
  #  - `sidekiq.redis.up` The network connection between the Sidekiq process
  #    and Redis has been restored.
  #  - `sidekiq.job.slow_iteration` An iterable job iteration took more than
  #    the graceful shutdown timeout, this can lead to duplicate job execution.
  #  - `sidekiq.hard_shutdown` One or more jobs did not finish in time for graceful
  #    shutdown and had to be killed mid-execution.
  class Notification
    # Name of the event, eg. "sidekiq.redis.slow_rtt"
    attr_reader :name
    # A hash of additional context which can be useful for debugging
    # or analysis
    attr_reader :context
    # The Sidekiq process PID in which this event occurred
    attr_reader :pid

    def initialize(name, ctx)
      @name = name
      @context = ctx
      @pid = ::Process.pid
    end

    def ==(other)
      @name == other.name &&
        @pid == other.pid &&
        @context == other.context
    end
  end
end
