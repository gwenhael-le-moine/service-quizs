# -*- coding: utf-8 -*-

# Objet suggestion_ass permettant de faire le lien avec la BDD
class SuggestionASS < Suggestion
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# id auto_increment
	# question_id Integer 
	# text String
	# Paramètres facultatifs
	# order Integer
	# medium_id Integer
	# position Enum ('L', 'R')
	def initialize ( params = {} )
		super(params)
	end

	# Permet de savoir si la suggestion est solution 
	# et de retourner les suggestions associées
  def solution?(marking = false)
  	is_solution = false
		solutions = Solutions.where(:right_suggestion_id => @id) if @position == 'R'
    solutions = Solutions.where(:left_suggestion_id => @id) if @position == 'L'
		unless solutions.nil? || solutions.empty?
			is_solution = []
			solutions.each do |solution|
        if !marking
          order = SuggestionASS.new({id: solution.left_suggestion_id}) if @position == 'R'
          order = SuggestionASS.new({id: solution.right_suggestion_id}) if @position == 'L'
          order = order.find.order
  				is_solution.push(order)
        else
          is_solution.push(solution.left_suggestion_id) if @position == 'R'
          is_solution.push(solution.right_suggestion_id) if @position == 'L'
        end
			end
		end
  	is_solution
  end

  # Récupère les ids des suggestions de la question
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
    left_suggestions_ids = []
    # On récupère toutes les suggestions gauche
    Suggestions.where(:question_id => @question_id, :position => @position).select(:id).each do |left_suggestion|
      left_suggestions_ids.push(left_suggestion.id);
    end
    datas = Solutions.where(:left_suggestion_id => left_suggestions_ids).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end

  # Récupère le nombre de réponses maximum dans la question
  def nb_responses_max
    nb_left_suggestions = Suggestions.where(:question_id => @question_id, :position => 'L').count
    nb_right_suggestions = Suggestions.where(:question_id => @question_id, :position => 'R').count
    nb_right_suggestions*nb_left_suggestions
  end
end