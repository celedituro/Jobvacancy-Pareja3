JobVacancy::App.controllers :reports, provides: [:json] do
  get :billing do
    job_repo = JobOfferRepository.new
    user_repo = UserRepository.new
    report_maker = ReportMaker.new(job_repo, user_repo)
    report = report_maker.make_report
    return report.to_json
  end
end
