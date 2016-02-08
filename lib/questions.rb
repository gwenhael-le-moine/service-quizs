# -*- coding: utf-8 -*-
# Module pour les Quizs

module Lib
  module Questions
    public

    module_function

    def self.user(user)
      @user = user
      # @user = {
      #   user: 'erasme',
      #   is_logged: true,
      #   uid: 'VAA60000',
      #   login: 'erasme',
      #   sexe: 'M',
      #   nom: 'Levallois',
      #   prenom: 'Pierre-Gilles',
      #   date_naissance: '1970-02-06',
      #   adresse: '1 rue Sans Nom Propre',
      #   code_postal: '69000',
      #   ville: 'Lyon',
      #   bloque: nil,
      #   id_jointure_aaf: nil,
      #   avatar: '',
      #   roles_max_priority_etab_actif: 3
      # }
    end

    # Fonction qui récupère une question et ses réponses
    # read permet de récupérer seulement les suggestions sans les solutions
    def self.get(id, read = false, marking = false, session_id = nil)
      question = Question.new(id: id)
      question = question.find
      question_found = {
        id: question.id,
        type: question.type.downcase,
        libelle: question.question,
        media: Lib::Medias.get(question.id, "question"),
        hint: {libelle: question.hint, media: {file: nil, type: nil}},
        randanswer: question.opt_rand_suggestion_order,
        answers: [],
        leurres: [],
        comment: question.correction_comment,
        sequence: question.order
      }
      question_found = get_all_suggestions(question_found, read, marking, session_id)
      {question_found: question_found}
    rescue => err
      LOGGER.error err.message + '     ' + err.backtrace.inspect
    end

    # Fonction qui récupère toutes les questions d'un quiz
    def self.get_all(quiz_id, read = false, marking = false, session_id = nil)
      questions_found = []
      questions = Question.new(quiz_id: quiz_id)
      questions = questions.find_all
      questions.each do |question|
        if read || (marking && session_id)
          questions_found.push(get(question.id, read, marking, session_id)[:question_found])
        else
          questions_found.push(            id: question.id,
                                           type: question.type,
                                           libelle: question.question,
                                           sequence: question.order)
        end
      end
      questions_found.sort_by! { |e| e[:sequence] }
      {questions_found: questions_found}
    rescue => err
      LOGGER.error err.message + err.backtrace.inspect
    end

    # Fonction qui créé une question avec leurs suggestions et solutions
    def self.create(quiz)
      order = Question.new(quiz_id: quiz[:id])
      order = order.find_all.count
      if @user[:uid] == quiz[:user_id]
        # création de la question
        params_question = {
          quiz_id: quiz[:id],
          type: quiz[:questions][0][:type].upcase,
          question: quiz[:questions][0][:libelle],
          order: order,
          opt_rand_suggestion_order: quiz[:questions][0][:randanswer],
          hint: quiz[:questions][0][:hint][:libelle],
          correction_comment: quiz[:questions][0][:comment],
        }
        question = Question.new(params_question)
        quiz[:questions][0][:id] = question.create.id

        # Création des médias
        medium = quiz[:questions][0][:media]
        if medium[:type] == 'video'
          quiz[:questions][0][:media][:id] = Lib::Medias.create(medium, quiz[:questions][0][:id], "question")
        end
        # Création des suggestions
        quiz = create_suggestions(quiz)
        {question_created: quiz[:questions][0]}
      end
    rescue => err
      LOGGER.error "Impossible de créer la nouvelle question ! message de l'erreur raise: " + err.message + '   ' + err.backtrace.inspect
      {question_created: {}, error: {msg: 'La création de la question a échoué !'}}
    end

    # Mise à jour de la question
    def self.update(quiz)
      if @user[:uid] == quiz[:user_id]
        params_question = {
          id: quiz[:questions][0][:id],
          question: quiz[:questions][0][:libelle],
          hint: quiz[:questions][0][:hint][:libelle],
          correction_comment: quiz[:questions][0][:comment],
          order: quiz[:questions][0][:sequence]
        }
        question = Question.new(params_question)
        question = question.find
        if quiz[:questions][0][:type].downcase != question.type.downcase
          question.delete
          quiz[:questions][0] = create(quiz)[:question_created]
        else
          question = Question.new(params_question)
          question.update
          quiz[:questions][0][:media] = Lib::Medias.update(quiz[:questions][0][:media], quiz[:questions][0][:id], "question") if quiz[:questions][0][:media][:type] == 'video'
          update_suggestions(quiz)
        end
        {question_updated: quiz[:questions][0]}
      end
    rescue => err
      LOGGER.error "Impossible de mettre à jour la question ! message de l'erreur raise: " + err.message + '   ' + err.backtrace.inspect
      {question_updated: {}, error: {msg: 'La mise à jour de la question a échoué !'}}
    end

    def self.update_order(quiz)
      if @user[:uid] == quiz[:user_id]
        quiz[:questions].each do |question|
          question_updated = Question.new(id: question[:id], order: question[:sequence])
          question_updated.update
        end
        {questions_updated: quiz[:questions]}
      end
    rescue => err
      LOGGER.error "Impossible de mettre à jour l'odre des questions ! message de l'erreur raise: " + err.message + '   ' + err.backtrace.inspect
      {questions_updated: [], error: {msg: "La mise à jour de l'ordre de la question a échoué !"}}
    end

    # Suppression de la question
    def self.delete(question_id)
      question = Question.new(id: question_id)
      question_deleted = question.delete
      {question_deleted: question_deleted}
    rescue => err
      LOGGER.error "Impossible de supprimer la question ! message de l'erreur raise: " + err.message
      {question_created: {}, error: {msg: 'La suppression de la question a échoué !'}}
    end

    private

    module_function

    def get_all_suggestions(question_found, read = false, marking = false, session_id = nil)
      case question_found[:type].upcase
      when 'QCM'
        response = Lib::SuggestionsQCM.get_all(question_found[:id], read, marking, session_id)
        question_found[:answers] = response[:answers]
        question_found[:solutions] = response[:solutions] if marking
      when 'TAT'
        response = Lib::SuggestionsTAT.get_all(question_found[:id], read, marking, session_id)
        question_found[:answers] = response[:answers]
        question_found[:solutions] = response[:solutions] if read || marking
        question_found[:leurres] = response[:leurres] if !read || !marking
      when 'ASS'
        response = Lib::SuggestionsASS.get_all(question_found[:id], read, marking, session_id)
        question_found[:answers] = response[:answers]
        question_found[:solutions] = response[:solutions] if marking
      end
      question_found
    end

    def create_suggestions(quiz)
      case quiz[:questions][0][:type]
      when 'qcm'
        quiz = Lib::SuggestionsQCM.create(quiz)
      when 'tat'
        quiz = Lib::SuggestionsTAT.create(quiz)
      when 'ass'
        quiz = Lib::SuggestionsASS.create(quiz)
      end
      quiz
    end

    def update_suggestions(quiz)
      # mise à jour des suggestions
      case quiz[:questions][0][:type]
      when 'qcm'
        Lib::SuggestionsQCM.update(quiz)
      when 'tat'
        Lib::SuggestionsTAT.update(quiz)
      when 'ass'
        Lib::SuggestionsASS.update(quiz)
      end
    end
  end
end
