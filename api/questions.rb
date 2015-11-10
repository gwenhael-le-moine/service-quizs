# -*- coding: utf-8 -*-

# Classe Grape de Quizs
class QuestionsApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Questions

  desc "créé une question"
  params do
    requires :quiz, type: Object, desc: 'quiz avec les nouvelles données à enregistrer'
  end
  post '/create' do
    Lib::Questions.user "user"
    # créé une nouvelle question et gère l'exception si besoin dans la lib
    Lib::Questions.create(params[:quiz])
  end

  desc "récupère la question"
  params do
    requires :id, type: Integer, desc: 'Id de la question'
  end
  get '/:id' do
    Lib::Questions.user "user"
    # récupère la question et gère l'exception si besoin dans la lib
    puts params[:id].class.inspect
    Lib::Questions.get(params[:id])
  end

  desc "récupère les questions d'un quiz"
  params do
    requires :quiz_id, type: Integer, desc: 'Id du quiz'
  end
  get '/all/:quiz_id' do
    Lib::Questions.user "user"
    # récupère les questions et gère l'exception si besoin dans la lib
    Lib::Questions.get_all(params[:quiz_id])
  end

  desc "met à jour la question d'un quiz"
  params do
    requires :quiz, type: Object, desc: 'quiz'
  end
  put '/update' do
    Lib::Questions.user "user"
    # récupère les questions et gère l'exception si besoin dans la lib
    Lib::Questions.update(params[:quiz])
  end

  desc "met à jour l'ordre des questions d'un quiz"
  params do
    requires :quiz, type: Object, desc: 'quiz'
  end
  put '/update/order' do
    Lib::Questions.user "user"
    # récupère les questions et gère l'exception si besoin dans la lib
    Lib::Questions.update_order(params[:quiz])
  end
 	
 	desc "supprime la question d'un quiz"
  params do
    requires :id, type: Integer, desc: 'Id de la question'
  end
  delete '/:id' do
    Lib::Questions.user "user"
    # récupère les questions et gère l'exception si besoin dans la lib
    Lib::Questions.delete(params[:id])
  end
end