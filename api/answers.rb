# -*- coding: utf-8 -*-

# Classe Grape de réponse
class AnswersApi < Grape::API
  format :json
  rescue_from :all

  include Lib::Answers

  desc 'créé une réponse'
  params do
    requires :quiz_id, type: Integer, desc: 'Id du quiz'
    requires :question, type: Object
    requires :session_id, type: Integer, desc: 'Id de la session du quiz'
  end
  post '/create' do
    Lib::Answers.user user
    # créé un nouveau quiz et gère l'exception si besoin dans la lib
    Lib::Answers.create(params)
  end
end
