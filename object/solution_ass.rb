# -*- coding: utf-8 -*-

# Objet solution ass permettant de faire le lien avec la BDD
class SolutionASS < Solution
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # left_suggestion_id Integer
  # right_suggestion_id Integer
  def initialize( params = {} )
    super(params)
  end

  # Mise à jour de la solution de droite d'une solution ass
  # id Integer
  # left_suggestion_id Integer permet de récupérer la solution
  # right_suggestion_id Integer permet de récupérer la solution
  def update
    solution = Solutions[id: @id]
    solution.update(left_suggestion_id: @left_suggestion_id) unless @left_suggestion_id.nil?
    solution.update(right_suggestion_id: @right_suggestion_id) unless @right_suggestion_id.nil?
    solution
  rescue => err
    raise_err err, "erreur lors de la mise à jour d'une solution ASS"
  end
end
