# -*- coding: utf-8 -*-

# Objet suggestion_tat permettant de faire le lien avec la BDD
class SuggestionTAT < Suggestion
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # id auto_increment
  # question_id Integer
  # text String
  # Paramètres facultatifs
  # order Integer
  # position Enum ('L', 'R')
  def initialize( params = {} )
    super(params)
  end

  # Permet de savoir si la suggestion est solution
  # et de retourner la suggestion associée
  def solution?
    is_solution = false
    if @position == 'L'
      solution = Solutions[left_suggestion_id: @id]
      is_solution = solution.right_suggestion_id unless solution.nil?
    end
    if @position == 'R'
      solution = Solutions[right_suggestion_id: @id]
      is_solution = solution.left_suggestion_id unless solution.nil?
    end
    is_solution
  end

  # Récupère les ids des suggestions gauche de la questions
  def find_all_ids
    ids = []
    solutions = []
    # on récupère toutes les solutions non null
    Solutions.all.each do |solution|
      solutions.push(solution.right_suggestion_id)
      solutions.push(solution.left_suggestion_id)
    end
    datas = Suggestions.where(question_id: @question_id, id: solutions).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end

  # Récupère les ids des leurres de la questions
  def find_all_leurres_ids
    ids = []
    solutions = []
    # on récupère toutes les solutions non null
    Solutions.exclude(right_suggestion_id: nil).select(:right_suggestion_id).each do |solution|
      solutions.push(solution.right_suggestion_id)
    end
    # on prends toutes les suggestions dont position est à R
    # d'une question qui n'ont pas de solution
    datas = Suggestions.where(question_id: @question_id, position: 'R').exclude(id: solutions).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end

  # Récupère les ids des solutions de la question
  def find_all_solutions_ids
    ids = []
    solutions = []
    # on récupère toutes les solutions non null
    Solutions.exclude(right_suggestion_id: nil).select(:right_suggestion_id).each do |solution|
      solutions.push(solution.right_suggestion_id)
    end
    # on prends toutes les suggestions dont position est à R
    # d'une question qui sont des solutions
    datas = Suggestions.where(question_id: @question_id, position: 'R', id: solutions).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end

  # dans le texte à trous, on ne peut pas avoir de réponses maximum
  # puisque l'on doit répondre à tout, du coup afin que ce  maximum,
  # ne soit jamais atteind, on ajoute 1 au nb de suggestion de gauche
  def nb_responses_max
    Suggestions.where(question_id: @question_id, position: 'L').count + 1
  end

  # duplique les suggestions
  def duplicate(new_question_id)
    suggestions = find_all
    suggestions.each do |suggestion_source|
      @id = suggestion_source.id
      @position = suggestion_source.position
      @question_id = new_question_id
      @text = suggestion_source.text
      @order = suggestion_source.order
      solution_id = solution?
      if @position == 'L'
        new_left_suggestion = create
        if solution_id
          new_right_suggestion = duplicate_right_suggestion_solution(solution_id, new_question_id)
          new_solution = SolutionTAT.new(left_suggestion_id: new_left_suggestion.id, right_suggestion_id: new_right_suggestion.id)
          new_solution.create
        end
      else
        create unless solution_id
      end
    end
  rescue => err
    raise_err err, "erreur lors du clonage d'une suggestion tat"
  end

  # Duplique la suggestion qui correspond à la solution du texte
  def duplicate_right_suggestion_solution(id_source, new_question_id)
    @id = id_source
    suggestion_source = find
    @position = suggestion_source.position
    @question_id = new_question_id
    @text = suggestion_source.text
    @order = suggestion_source.order
    # @leurre_id = suggestion_source.leurre_id
    create
  rescue => err
    raise_err err, 'erreur lors du clonage de la suggestion solution de droite'
  end
end
