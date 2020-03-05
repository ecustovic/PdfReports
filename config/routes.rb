Rails.application.routes.draw do
  mount Pixelpress::Engine => "rails" if Rails.env.development?

  resources :games do
    collection do
      get "pdfkit", "weasyprint", "rails_pdf"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
