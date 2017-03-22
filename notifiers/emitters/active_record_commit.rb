class Notifiers::Emitters::ActiveRecordCommit < Notifiers::Emitter

  KEY = "commit.active_record.open2view"

  def self.run

    self._debug("Initializing after_comment on all ActiveRecord models")
    
    ActiveRecord::Base.class_eval do
      
      after_commit :_notify_all_commits

      def _notify_all_commits
        Notifiers::Emitter.emit(KEY, {
          id:    self.id,
          klass: self.class.to_s
        })
      end
    end
  end
end