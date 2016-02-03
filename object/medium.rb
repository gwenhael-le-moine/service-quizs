# -*- coding: utf-8 -*-

# Objet Medium permettant de faire le lien avec la BDD
class Medium
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # id Integer
  # content_type String
  # uri String
  # Paramètres facultatifs
  # name String
  # created_at DateTime
  def initialize( params = {} )
    @id = params[:id]
    @name = params[:name]
    @content_type = params[:content_type]
    @uri = params[:uri]
    @created_at = Time.now.to_s(:db)
  end

  # Création d'une réponse
  def create
    medium = Medias.new
    medium.name = @name
    medium.content_type = @content_type
    medium.uri = @uri
    medium.created_at = @created_at
    # On enregistre la réponse
    medium.save
    @id = medium.id
    medium
  rescue => err
    raise_err err, "erreur lors de la création d'un medium"
  end

  # Récupération d'un médium par rapport à son id
  def find
    Medias[id: @id]
  end

  # Suppression d'un médium par rapport à son id
  def delete
    medium = Medias[id: @id]
    medium.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'un medium"
  end
end
