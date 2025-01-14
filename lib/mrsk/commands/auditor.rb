require "active_support/core_ext/time/conversions"

class Mrsk::Commands::Auditor < Mrsk::Commands::Base
  # Runs remotely
  def record(line)
    append \
      [ :echo, tagged_record_line(line) ],
      audit_log_file
  end

  # Runs locally
  def broadcast(line)
    if broadcast_cmd = config.audit_broadcast_cmd
      [ broadcast_cmd, tagged_broadcast_line(line) ]
    end
  end

  def reveal
    [ :tail, "-n", 50, audit_log_file ]
  end

  private
    def audit_log_file
      "mrsk-#{config.service}-audit.log"
    end

    def tagged_record_line(line)
      "'#{recorded_at_tag} #{performer_tag} #{line}'"
    end

    def tagged_broadcast_line(line)
      "'#{performer_tag} #{line}'"
    end

    def performer_tag
      "[#{`whoami`.strip}]"
    end

    def recorded_at_tag
      "[#{Time.now.to_fs(:db)}]"
    end
end
