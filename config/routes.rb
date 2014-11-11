Rails.application.routes.draw do

  get "tasks", to: "tasks#index"
  get "tasks/character_upload", to: "tasks#character_upload", as: 'character_upload'
  post "tasks/validate_heroclass", to: "tasks#validate_heroclass"

end
