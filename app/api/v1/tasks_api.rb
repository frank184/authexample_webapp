class V1::TasksApi < Grape::API
  format :json

  namespace :tasks do
    get '/' do
      {
        "tasks":[
          {"title":"Complete the app"},
          {"title":"Complete the tutorial"}
        ]
      }
    end
  end
end
