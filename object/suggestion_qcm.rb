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
end