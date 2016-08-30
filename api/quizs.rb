# -*- coding: utf-8 -*-

# Classe Grape de Quizs
class QuizsApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Quizs

  desc 'créé un quiz'
  get '/create' do
    Lib::Quizs.user user
    # créé un nouveau quiz et gère l'exception si besoin dans la lib
    Lib::Quizs.create
  end

  desc 'récupère un quiz'
  params do
    requires :id, type: Integer, desc: 'Id du quiz'
  end
  get '/:id' do
    Lib::Quizs.user user
    # récupère un quiz et gère l'exception si besoin dans la lib
    Lib::Quizs.get(params[:id])
  end

  desc "récupère les quizs de l'utlisateur courant"
  params do
    optional :shared, type: Boolean, desc: 'boolean permattant de récupérer les quizs partagés'
  end
  get '/' do
    Lib::Quizs.user user
    # récupère un quiz et gère l'exception si besoin dans la lib
    if params[:shared]
      Lib::Quizs.shared
    else
      Lib::Quizs.all
    end
  end

  desc 'met à jour les paramètres du quiz'
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
    Lib::Quizs.user user
    # Met à jour le quiz
    Lib::Quizs.update(params)
  end

  desc 'supprime un quiz'
  params do
    requires :id, type: Integer, desc: 'Id du quiz'
  end
  delete '/:id' do
    Lib::Quizs.user user
    # supprime un quiz et gère l'exception si besoin dans la lib
    Lib::Quizs.delete(params[:id])
  end

  desc 'duplique un quiz'
  params do
    requires :id, type: Integer, desc: 'Id du quiz'
  end
  get 'duplicate/:id' do
    Lib::Quizs.user user
    # duplique un quiz et gère l'exception si besoin dans la lib
    Lib::Quizs.duplicate(params[:id])
  end
end
