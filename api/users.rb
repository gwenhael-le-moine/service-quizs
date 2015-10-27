# -*- coding: utf-8 -*-

# Classe Grape de blogs
class UsersApi < Grape::API
  format :json
  rescue_from :all

  desc "récupère l'utilisateur courant"
  get '/current' do
    user
  end
end
