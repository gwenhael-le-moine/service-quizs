# -*- coding: utf-8 -*-

# Objet suggestion_qcm permettant de faire le lien avec la BDD
class SuggestionQCM < Suggestion
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# id auto_increment
	# question_id Integer 
	# text String
	# Paramètres facultatifs
	# order Integer
	# medium_id Integer
	# position 'L'
	def initialize ( params = {} )
		params[:position] = 'L'
		super(params)
	end

	# Permet de savoir si la suggestion est solution 
  def solution?
  	is_solution = false
  	is_solution = true if Solutions[:left_suggestion_id => @id]
  	is_solution
  end

  # Récupère les ids des suggestions de la questions
  def find_all_ids
  	ids = []
  	datas = Suggestions.where(:question_id => @question_id).select(:id)
  	datas.each do |data|
  		ids.push(data.id)
  	end
  	ids
  end

  # Récupère les ids des solutions de la question
  def find_all_solutions_ids
  	ids = []
  	sugestions_ids = find_all_ids
  	datas = Solutions.where(:left_suggestion_id => sugestions_ids).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end

  # Récupère le nombre de réponses maximum dans la question
  def nb_responses_max
    find_all_ids.size
  end

  # duplique la suggestion
  def duplicate(new_question_id)
    suggestions = find_all
    suggestions.each do |suggestion_source|
      @question_id = new_question_id
      @text = suggestion_source.text
      @order = suggestion_source.order
      @position = suggestion_source.position
      @medium_id = suggestion_source.medium_id
      new_suggestion = create
      @id = suggestion_source.id
      if solution?
        new_solution = SolutionQCM.new({left_suggestion_id: new_suggestion.id})
        new_solution.create
      end
    end
  rescue => err
    raise_err err, "erreur lors du clonage d'une suggestion qcm"
  end
end