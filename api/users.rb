# -*- coding: utf-8 -*-

# Classe Grape de blogs
class UsersApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Users

  desc "récupère l'utilisateur courant"
  get '/current' do
    user
  end

  desc "récupère les regoupements de l'utilisateurs"
  params do
  	requires :quiz_id, type: Integer, desc: 'Id du quiz'
  end
  get '/regroupements/:quiz_id' do
    Lib::Users.user user
    # Met à jour le quiz
    Lib::Users.get_regroupements(params[:quiz_id])
  end
end
