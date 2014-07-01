module RetryJob
  def on_failure_retry(e, *args)
    Rails.logger.info "Performing #{self} caused an exception (#{e}). Retrying..."
    Resque.enqueue self, *args
  end
end