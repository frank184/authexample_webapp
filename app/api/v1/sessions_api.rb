class V1::SessionsApi < V1::ApiBase
  get '/' do
    'AuthexampleWebappV1'
  end

  namespace :sessions do
    post '/' do
      warden.authenticate!(
        scope: resource_name,
        recall: "#{controller_path}#failure"
      )
    end
  end
end
