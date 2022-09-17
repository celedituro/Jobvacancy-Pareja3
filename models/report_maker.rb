class ReportMaker
  attr_accessor :job_repo, :user_repo

  def initialize(job_repo, user_repo)
    @job_repo = job_repo
    @user_repo = user_repo
  end

  def make_report
    {
      items: [],
      total_amount: 0.0
    }
  end
end
