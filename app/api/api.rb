class Api < Grape::API
  prefix :api
  version :v1, using: :path
  format :json
  mount V1::Init
end