# -*- coding: utf-8 -*-

# Classe Grape de Sessions
class SessionsApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Sessions

  desc "créé une session"
  params do 
    requires :quiz_id, type: Integer, desc: 'Id de la plublication du quiz'
  end
  post '/create' do
    Lib::Sessions.user user
    # créé un nouveau quiz et gère l'exception si besoin dans la lib
    Lib::Sessions.create(params[:quiz_id])
  end

  desc "récupère les sessions de l'utilisateur"
  get '/' do
    Lib::Sessions.user user
    # Met à jour le quiz
    Lib::Sessions.get_all
  end

  desc "récupère une session"
  params do
    requires :id, type: Integer, desc: 'Id de la session'
  end
  get '/:id' do
    Lib::Sessions.user user
    # Met à jour le quiz
    Lib::Sessions.get(params[:id])
  end

  desc "vérifie qu'une session d'un quiz existe pour l'utilisateur"
  params do
    requires :quiz_id, type: Integer, desc: 'Id du quiz'
  end
  get 'exist/:quiz_id' do
    Lib::Sessions.user user
    # Met à jour le quiz
    Lib::Sessions.exist?(params[:quiz_id])
  end
end