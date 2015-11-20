# -*- coding: utf-8 -*-

# Objet solution qcm permettant de faire le lien avec la BDD
class SolutionQCM < Solution
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# Id Integer
	# left_suggestion_id Integer
	def initialize ( params = {} )
		params[:right_suggestion_id] = nil
		super(params)
	end

	# Récupère la solution avec left_suggestion_id
  def find
    Solutions[:left_suggestion_id => @left_suggestion_id]
  end

	 # Suppression d'une solution qcm
  def delete
  	solution = Solutions[:left_suggestion_id => @left_suggestion_id]
  	solution.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une solution QCM"
  end
end