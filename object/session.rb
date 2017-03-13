# -*- coding: utf-8 -*-

# Objet session permettant de faire le lien avec la BDD
class Session
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # id auto_increment
  # publication_id Integer
  # user_id String
  # user_type String
  # created_at DateTime
  # score Float
  # Paramètres facultatifs
  # updated_at DateTime
  def initialize( params = {} )
    @id = params[:id]
    @publication_id = params[:publication_id]
    @user_id = params[:user_id]
    @user_type = params[:user_type]
    @created_at = Time.now.to_s(:db)
    @updated_at = Time.now.to_s(:db)
    @score = params[:score]
  end

  # Création d'une session
  def create
    session = Sessions.new
    session.publication_id = @publication_id
    session.user_id = @user_id
    session.user_type = @user_type
    session.created_at = @created_at
    session.updated_at = @updated_at
    session.score = @score
    session.save
    @id = session.id
    session
  rescue => err
    raise_err err, "erreur lors de la création d'une session"
  end

  # Récupére une session
  def find
    Sessions[id: @id]
  end

  # Récupère toutes les sessions d'une  publication
  def find_all
    sessions = []
    sessions = Sessions.where(publication_id: @publication_id) unless @publication_id.nil? || !@user_id.nil? || !@user_type.nil?
    sessions = Sessions.where(publication_id: @publication_id, user_id: @user_id, user_type: @user_type) unless @publication_id.nil? || @user_id.nil? || @user_type.nil?
    sessions = Sessions.where(user_id: @user_id, user_type: @user_type) unless !@publication_id.nil? || @user_id.nil? || @user_type.nil?
    sessions
  end

  # Récupère toutes les sessions des élèves pour les quizs d'un prof
  def find_all_elv_of_prof(quizs_ids)  
    Sessions.where( publication_id: Publications.where( quiz_id: quizs_ids ).select(:id).all.map(&:id) ).all
  end

  # mise à jour de la session
  # score Integer
  def update
    session = Sessions[id: @id]
    session.update(score: @score) unless @score.nil?
    # Mise à jour de la date updated_at
    session.update(updated_at: Time.now.to_s(:db))
    session
  rescue => err
    raise_err err, "erreur lors de la mise à jour d'une session"
  end

  # Supprimer une session
  def delete
    session = Sessions[id: @id]
    session.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une session"
  end
  
end
