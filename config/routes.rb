Rails.application.routes.draw do
  resource :electricity_consumption, only: ['show'], controller: 'electricity_consumption'
end
