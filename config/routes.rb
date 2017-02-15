Rails.application.routes.draw do
  namespace :foreman_virt_who_configure do
    resources :configs do
      collection do
        get 'auto_complete_search'
      end
      member do
        post 'deploy'
      end
    end
  end
end
