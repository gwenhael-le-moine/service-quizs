# -*- coding: utf-8 -*-

module Lib
  module Imports
    public

    module_function

    def self.set(datas)
      DB.transaction do
        quizs = create_quizs(datas) unless datas.nil?
        {quizs: quizs}
      end
    rescue => err
      LOGGER.error err.message
      {quizs: [], error: "L'importation a échoué"}
    end

    private

    module_function

    def create_quizs(quizs)
      quizs.each do |quiz|
        new_quiz = Quiz.new(quiz)
        new_quiz = new_quiz.create
        quiz[:id] = new_quiz.id
        quiz[:questions] = create_questions(quiz[:questions], quiz[:id])
      end
      quizs
    end

    def create_questions(questions, new_quiz_id)
      questions.each do |question|
        question[:quiz_id] = new_quiz_id
        new_question = Question.new(question)
        new_question = new_question.create
        question[:id] = new_question.id
        result = create_suggestions(question[:suggestions], question[:id], question[:type], question[:leurres])
        question[:suggestions] = result[:suggestions]
        question[:leurres] = result[:leurres]
      end
      questions
    end

    def create_suggestions(suggestions, new_question_id, type, leurres)
      case type
      when 'QCM'
        suggestions = create_suggestions_qcm(suggestions, new_question_id)
      when 'TAT'
        suggestions = create_suggestions_tat(suggestions, new_question_id)
        leurres = create_leurres(leurres, new_question_id)
      when 'ASS'
        suggestions = create_suggestions_ass(suggestions, new_question_id)
      end
      {suggestions: suggestions, leurres: leurres}
    end

    ############## QCM ##############
    def create_suggestions_qcm(suggestions, new_question_id)
      suggestions.each do |suggestion|
        suggestion[:question_id] = new_question_id
        new_suggestion_qcm = SuggestionQCM.new(suggestion)
        new_suggestion_qcm = new_suggestion_qcm.create
        suggestion[:id] = new_suggestion_qcm.id
        create_solution_qcm(suggestion[:solution], new_suggestion_qcm.id)
      end
      suggestions
    end

    def create_solution_qcm(solution, suggestion_id)
      return false unless solution
      new_solution_qcm = SolutionQCM.new(left_suggestion_id: suggestion_id)
      new_solution_qcm.create
    end

    ############### TAT ###############
    def create_suggestions_tat(suggestions, new_question_id)
      suggestions.each do |suggestion|
        suggestion[:left] = create_suggestion_tat(suggestion[:left], new_question_id)
        suggestion[:right] = create_suggestion_tat(suggestion[:right], new_question_id)
        create_solution_tat(suggestion[:left][:id], suggestion[:right][:id])
      end
    end

    def create_solution_tat(left_suggestion_id, right_suggestion_id)
      new_solution_tat = SolutionTAT.new(left_suggestion_id: left_suggestion_id, right_suggestion_id: right_suggestion_id)
      new_solution_tat.create
    end

    def create_leurres(leurres, new_question_id)
      leurres.each do |leurre|
        leurre[:id] = create_suggestion_tat(leurre, new_question_id)[:id]
      end
      leurres
    end

    def create_suggestion_tat(suggestion, new_question_id)
      unless suggestion.nil?
        suggestion[:question_id] = new_question_id
        new_suggestion_tat = SuggestionTAT.new(suggestion)
        new_suggestion_tat = new_suggestion_tat.create
        suggestion[:id] = new_suggestion_tat.id
      end
      suggestion
    end

    ################ ASS #######################
    def create_suggestions_ass(suggestions, new_question_id)
      # Premier tour pour créer les suggestions
      suggestions.each do |suggestion|
        suggestion[:left] = create_suggestion_ass(suggestion[:left], new_question_id)
        suggestion[:right] = create_suggestion_ass(suggestion[:right], new_question_id)
      end
      # Deuxième tour pour créer les solutions
      suggestions.each do |suggestion|
        create_solutions_ass(suggestion[:left][:solutions], suggestions, suggestion[:left][:id])
      end
    end

    def create_suggestion_ass(suggestion, new_question_id)
      unless suggestion.nil?
        suggestion[:question_id] = new_question_id
        new_suggestion_ass = SuggestionASS.new(suggestion)
        new_suggestion_ass = new_suggestion_ass.create
        suggestion[:id] = new_suggestion_ass.id
      end
      suggestion
    end

    def create_solutions_ass(solutions, suggestions, left_suggestion_id)
      solutions.each do |solution|
        right_suggestion_id = suggestions[solution][:right][:id]
        new_solution_ass = SolutionASS.new(left_suggestion_id: left_suggestion_id, right_suggestion_id: right_suggestion_id)
        new_solution_ass.create
      end
    end
  end
end
