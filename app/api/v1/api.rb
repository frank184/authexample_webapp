class V1::Api < Grape::API
  mount SessionsApi
  mount RegistrationsApi
  mount TasksApi
end
