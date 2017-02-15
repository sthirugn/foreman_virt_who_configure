if ForemanVirtWhoConfigure.with_remote_execution?
  User.as_anonymous_admin do
    JobTemplate.without_auditing do
      Dir[File.join("#{ForemanVirtWhoConfigure::Engine.root}/app/views/foreman/job_templates/**/*.erb")].each do |template|
        JobTemplate.import!(File.read(template), :default => true, :locked => true, :update => true)
      end
    end
    feature = RemoteExecutionFeature.find_by_label('deploy_virt_who_config')
    # if feature && feature.job_template_id.nil?
      feature.job_template = JobTemplate.find_by_name('Deploy virt-who configuration')
      feature.save!
    # end
  end
end
