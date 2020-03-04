json.extract! game, :id, :title, :genre, :platform, :created_at, :updated_at
json.url game_url(game, format: :json)
