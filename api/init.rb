# -*- coding: utf-8 -*-

require 'laclasse/helpers/authentication'
require 'laclasse/cross_app/sender'
require 'laclasse/helpers/user'

puts 'loading api/UsersApi'
require __dir__('users')

puts 'loading api/QuizsApi'
require __dir__('quizs')

puts 'loading api/QuestionsApi'
require __dir__('questions')


# Point d'entrée des API de quiz
class Api < Grape::API
  format :json
  rescue_from :all

  # helpers Laclasse::Helpers::Authentication
  # helpers Laclasse::Helpers::User

  # before do
  #   error!( '401 Unauthorized', 401 ) unless logged?
  # end

  # Montage des toutes les api REST Grape
  resource(:users) { mount UsersApi }
  resource(:quizs) { mount QuizsApi }
  resource(:questions) { mount QuestionsApi }

  add_swagger_documentation
end
