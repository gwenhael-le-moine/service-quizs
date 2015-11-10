# -*- coding: utf-8 -*-

# Objet solution permettant de faire le lien avec la BDD
class Solution
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# id Integer auto_increment
	# left_suggestion_id Integer
	# Paramètres facultatifs
	# right_suggestion_id Integer
	def initialize ( params = {} )
		@id = params[:id]
		@left_suggestion_id = params[:left_suggestion_id]
		@right_suggestion_id = params[:right_suggestion_id]
	end

	# Création d'une solution
	def create
		solution = Solutions.new
		solution.left_suggestion_id = @left_suggestion_id
		solution.right_suggestion_id = @right_suggestion_id
		# On enregistre la solution
		solution.save
		@id = solution.id
		# on récupère l'id auto généré
		solution
	rescue => err
    raise_err err, "erreur lors de la création d'une solution"
  end

  # Suppression d'une solution qcm
  def delete
  	solution = Solutions[:id => @id]
  	solution.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une solution QCM"
  end
end