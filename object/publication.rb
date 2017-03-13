# -*- coding: utf-8 -*-

# Objet publication permettant de faire le lien avec la BDD
class Publication
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # id auto_increment
  # quiz_id Integer
  # rgpt_id Integer
  # opt_show_score Enum('after_each', 'at_end', 'none')
  # opt_show_correct Enum('after_each', 'at_end', 'none')
  # opt_can_redo Boolean
  # opt_can_rewind Boolean
  # opt_rand_question_order Boolean
  # Paramètres facultatifs
  # from_date DateTime
  # to_date DateTime
  def initialize( params = {} )
    @id = params[:id]
    @quiz_id = params[:quiz_id]
    @rgpt_id = params[:rgpt_id]
    @opt_can_redo = params[:opt_can_redo]
    @opt_can_rewind = params[:opt_can_rewind]
    @opt_rand_question_order = params[:opt_rand_question_order]
    @opt_show_score = params[:opt_show_score]
    @opt_show_correct = params[:opt_show_correct]
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    @index_publication = params[:index_publication]
  end

  # Création d'une publication
  def create
    publication = Publications.new
    publication.quiz_id = @quiz_id
    publication.rgpt_id = @rgpt_id
    publication.opt_can_redo = @opt_can_redo
    publication.opt_can_rewind = @opt_can_rewind
    publication.opt_rand_question_order = @opt_rand_question_order
    publication.opt_show_score = @opt_show_score
    publication.opt_show_correct = @opt_show_correct
    publication.from_date = @from_date
    publication.to_date = @to_date
    publication.index_publication = @index_publication
    # On enregistre le publication
    publication.save
    # on récupère l'id auto généré
    @id = publication.id
    publication
  rescue => err
    raise_err err, "erreur lors de la création d'une publication"
  end

  # Récupération d'une publication par rapport à son id
  def find
    Publications[id: @id]
  end

  # Récupération d'une liste de publications par rapport à
  # quiz_id Integer
  # rgpt_id Integer
  def find_all
    publications = []
    # Récupération des publications d'un quiz
    publications = Publications.where(quiz_id: @quiz_id) unless @quiz_id.nil?
    # Récupération des publications d'un regroupement
    publications = Publications.where(rgpt_id: @rgpt_id) unless @rgpt_id.nil?
    publications
  end

  # Mise à jour des données d'une publication
  # id Integer permet de récupérer la publication
  # opt_show_score Enum('after_each', 'at_end', 'none')
  # opt_show_correct Enum('after_each', 'at_end', 'none')
  # opt_can_redo Boolean
  # opt_can_rewind Boolean
  # opt_rand_question_order Boolean
  # from_date DateTime
  # to_date DateTime
  def update
    publication = Publications[id: @id]
    publication.update(opt_show_score: @opt_show_score) unless @opt_show_score.nil?
    publication.update(opt_show_correct: @opt_show_correct) unless @opt_show_correct.nil?
    publication.update(opt_can_redo: @opt_can_redo) unless @opt_can_redo.nil?
    publication.update(opt_can_rewind: @opt_can_rewind) unless @opt_can_rewind.nil?
    publication.update(opt_rand_question_order: @opt_rand_question_order) unless @opt_rand_question_order.nil?
    publication.update(from_date: @from_date) unless @from_date.nil?
    publication.update(to_date: @to_date) unless @to_date.nil?
    publication.update(index_publication: @index_publication) unless @index_publication.nil?
    publication
      
     rescue => err
    raise_err err, "erreur lors de la mise à jour d'une publication"
end

  # Suppression d'une publication
  def delete
    publication = Publications[id: @id]
    publication.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une publication"
  end

  # vérifi si le quiz est déjà publié dans un regroupement
  def exist?
    !Publications[quiz_id: @quiz_id, rgpt_id: @rgpt_id].nil?
  rescue => err
    raise_err err, "erreur lors de la vérification de l'existance d'une publication"
  end
end
