# -*- coding: utf-8 -*-

# Objet suggestion permettant de faire le lien avec la BDD
class Suggestion
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # id auto_increment
  # question_id Integer
  # text String
  # position Enum('L', 'R')
  # Paramètres facultatifs
  # order Integer
  # medium_id Integer
  def initialize( params = {} )
    @id = params[:id]
    @question_id = params[:question_id]
    @text = params[:text]
    @order = params[:order]
    @position = params[:position]
    @medium_id = params[:medium_id]
  end

  # Création d'une suggestion
  def create
    suggestion = Suggestions.new
    suggestion.question_id = @question_id
    suggestion.text = @text
    suggestion.order = @order
    suggestion.position = @position
    suggestion.medium_id = @medium_id
    # On enregistre la suggestion
    suggestion.save
    # on récupère l'id auto généré
    @id = suggestion.id
    suggestion
  rescue => err
    raise_err err, "erreur lors de la création d'une suggestion"
  end

  # Récupération d'une suggestion par rapport à son id
  def find
    Suggestions[id: @id]
  end

  # Récupération d'une liste de suggestions par rapport à
  # question_id Integer
  def find_all
    suggestions = []
    # Récupération des suggestions d'un quiz
    suggestions = Suggestions.where(question_id: @question_id) unless @question_id.nil?
    suggestions
  end

  # Mise à jour des données d'une suggestion
  # id Integer permet de récupérer la suggestion
  # text String
  # order Integer
  # medium_id Integer
  def update
    suggestion = Suggestions[id: @id]
    suggestion.update(text: @text) unless @text.nil?
    suggestion.update(order: @order) unless @order.nil?
    suggestion.update(medium_id: @medium_id) unless @medium_id.nil?
    suggestion
  rescue => err
    raise_err err, "erreur lors de la mise à jour d'une suggestion"
  end

  # Suppression d'une suggestion
  def delete
    suggestion = Suggestions[id: @id]
    suggestion.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une suggestion"
  end
end
