# -*- coding: utf-8 -*-

# Classe Grape de Quizs
class QuizsApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Quizs

  desc "créé un quiz"
  get '/create' do
    Lib::Quizs.user "user"
    # créé un nouveau quiz et gère l'exception si besoin dans la lib
    Lib::Quizs.create
  end

  desc "récupère un quiz"
  params do
    requires :id, type: Integer, desc: 'Id du quiz'
  end
  get '/:id' do
    Lib::Quizs.user "user"
    # récupère un quiz et gère l'exception si besoin dans la lib
    Lib::Quizs.get(params[:id])
  end

  desc "met à jour les paramètres du quiz"
  params do
    requires :id, type: Integer, desc: 'Id du quiz'
    optional :opt_show_score, type: String, desc: 'opt affichage du score'
    optional :opt_show_correct, type: String, desc: 'opt affichage de la correction'
    optional :title, type: String, desc: 'titre du quiz'
    optional :opt_can_redo, type: Boolean, desc: 'opt refaire le quiz'
    optional :opt_can_rewind, type: Boolean, desc: 'opt rejouer les questions'
    optional :opt_rand_question_order, type: Boolean, desc: 'opt mélanger les questions'
    optional :opt_shared, type: Boolean, desc: 'opt partager le quiz'
  end
  post '/update/:id' do
    Lib::Quizs.user "user"
    # Met à jour le quiz
    Lib::Quizs.update(params)
  end
end