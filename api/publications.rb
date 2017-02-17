# -*- coding: utf-8 -*-

# Classe Grape de réponse
class PublicationsApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Publications

  desc "récupère les publications d'un quiz"
  params do
    requires :quiz_id, type: Integer, desc: 'Id du quiz'
  end
  get '/:quiz_id' do
    Lib::Publications.user user
    # créé un nouveau quiz et gère l'exception si besoin dans la lib
    Lib::Publications.get_all(params[:quiz_id])
  end

  desc "supprime les publications d'un quiz"
  params do
    requires :quiz_id, type: Integer
    optional :added, type: Array, desc: 'Liste des regroupements à ajouter'
    optional :deleted, type: Array, desc: 'Liste des publication à supprimer'
    optional :fromDate, type: DateTime
    optional :toDate, type: DateTime
  end
  post '/:quiz_id' do
    Lib::Publications.user user
    # créé un nouveau quiz et gère l'exception si besoin dans la lib
    Lib::Publications.add(params) unless params[:added].nil? || params[:added].empty?
    Lib::Publications.delete(params[:deleted]) unless params[:deleted].nil? || params[:deleted].empty?
  end
end
