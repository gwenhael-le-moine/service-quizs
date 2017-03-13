# -*- coding: utf-8 -*-

# Classe Grape de Sessions
class SessionsApi < Grape::API
  format :json
  rescue_from :all
  content_type :json, 'application/json'
  content_type :pdf, 'application/pdf'

  include Lib::Sessionslib

  desc 'créé une session'
  params do
    requires :publication_id, type: Integer, desc: 'Id  du quiz'
  end
  post '/create' do
    puts("create params[:publication_id]")
    puts(params[:publication_id])
    Lib::Sessionslib.user user
    # gère l'exception si besoin dans la lib
    Lib::Sessionslib.create(params[:publication_id])
  end

  desc "récupère les sessions de l'utilisateur"
  params do
    optional :publication_id, type: Integer, desc: 'Id du quiz'
  end
  get '/' do
    Lib::Sessionslib.user user
    # gère l'exception si besoin dans la lib
    Lib::Sessionslib.get_all(params[:publication_id])
  end

  desc 'récupère une session'
  params do
    requires :id, type: Integer, desc: 'Id de la session'
  end
  get '/:id' do
    Lib::Sessionslib.user user
    # gère l'exception si besoin dans la lib
    Lib::Sessionslib.get(params[:id])
  end

  desc "vérifie qu'une session d'un quiz existe pour l'utilisateur"
  params do
    requires :publication_id, type: Integer, desc: 'Id du quiz'
  end
  get 'exist/:publication_id' do
    Lib::Sessionslib.user user
    # gère l'exception si besoin dans la lib
    Lib::Sessionslib.exist?(params[:publication_id])
  end

  desc 'Supprime une ou plusieurs sessions'
  params do
    requires :ids, type: Array, desc: 'les ids des sessions à supprimer'
  end
  post '/delete' do
    Lib::Sessionslib.user user
    # gère l'exception si besoin dans la lib
    Lib::Sessionslib.delete(params[:ids])
  end

  desc 'Génère un pdf des sessions'
  params do
    requires :sessions, type: Array, desc: 'les données des sessions à générer'
  end
  post '/pdf' do
    Lib::Sessionslib.user user
    # gère l'exception si besoin dans la lib
    content_type 'application/pdf'
    Lib::Sessionslib.generate_pdf(params[:sessions])
  end
end
