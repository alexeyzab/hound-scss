require "review"

class ScssReviewJob
  @queue = :scss_review

  # The following parameters are required for this job to run.
  # - filename
  # - commit_sha
  # - pull_request_number (pass-through)
  # - patch (pass-through)
  # - content
  # - config
  def self.perform(attributes)
    Review.run(attributes)
  end
end
