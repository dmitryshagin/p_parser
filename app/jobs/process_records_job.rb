class ProcessRecordsJob < ApplicationJob
  queue_as :default

  def perform(request)
    request.process
  end
end
