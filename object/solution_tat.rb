# -*- coding: utf-8 -*-

# Objet solution tat permettant de faire le lien avec la BDD
class SolutionTAT < Solution
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# left_suggestion_id Integer
	# right_suggestion_id Integer
	def initialize ( params = {} )
		super(params)
	end
end