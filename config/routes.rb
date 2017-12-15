Rails.application.routes.draw do
  resources :electricity_consumption_reports,
            only: ['create']
end
