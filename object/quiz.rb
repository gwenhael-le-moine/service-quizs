# -*- coding: utf-8 -*-

# Objet quiz permettant de faire le lien avec la BDD
class Quiz
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# id auto_increment
	# user_id String 
	# opt_show_score Enum('after_each', 'at_end', 'none')
	# opt_show_correct Enum('after_each', 'at_end', 'none')
	# opt_can_redo Boolean
	# opt_can_rewind Boolean
	# opt_rand_question_order Boolean
	# opt_shared Boolean
	# Paramètres facultatifs
	# created_at DateTime
	# updated_at DateTime
	# title String
	def initialize ( params = {} )
		@id = params[:id]
		@user_id = params[:user_id]
		@opt_can_redo = params[:opt_can_redo]
		@opt_can_rewind = params[:opt_can_rewind]
		@opt_rand_question_order = params[:opt_rand_question_order]
		@opt_shared = params[:opt_shared]
		@opt_show_score = params[:opt_show_score]
		@opt_show_correct = params[:opt_show_correct]
		@created_at = Time.now.to_s(:db)
		@updated_at = Time.now.to_s(:db)
		@title = params[:title]
	end

	# Création d'un quiz
	def create
		quiz = Quizs.new
		quiz.user_id = @user_id
		quiz.opt_can_redo = @opt_can_redo
		quiz.opt_can_rewind = @opt_can_rewind
		quiz.opt_rand_question_order = @opt_rand_question_order
		quiz.opt_shared = @opt_shared
		quiz.opt_show_score = @opt_show_score
		quiz.opt_show_correct = @opt_show_correct
		quiz.created_at = @created_at
		quiz.updated_at = @updated_at
		quiz.title = @title
		# On enregistre le quiz
		quiz.save
		# on récupère l'id auto généré
		@id = quiz.id
		quiz
	rescue => err
    raise_err err, "erreur lors de la création d'un quiz"
  end

  # Récupération d'un quiz par rapport à son id
  def find
  	Quizs[:id => @id]
  end

  # Récupération d'une liste de quizs par rapport à
  # user_id String 
  # opt_shared Boolean 
  def find_all
  	quizs = []
  	# Récupération des quizs d'un utilisateur
  	quizs = Quizs.where(:user_id => @user_id) unless @user_id.nil?
  	# Récupération des quizs partagés
  	quizs = Quizs.where(:opt_shared => @opt_shared) unless @opt_shared.nil?
  	quizs
  end

  # Mise à jour des données d'un quiz
  # id Integer permet de récupérer le quiz
  # title String
  # opt_show_score Enum('after_each', 'at_end', 'none')
	# opt_show_correct Enum('after_each', 'at_end', 'none')
	# opt_can_redo Boolean
	# opt_can_rewind Boolean
	# opt_rand_question_order Boolean
	# opt_shared Boolean
  def update
  	quiz = Quizs[:id => @id]
  	quiz.update(title: @title) unless @title.nil?
  	quiz.update(opt_show_score: @opt_show_score) unless @opt_show_score.nil?
  	quiz.update(opt_show_correct: @opt_show_correct) unless @opt_show_correct.nil?
  	quiz.update(opt_can_redo: @opt_can_redo) unless @opt_can_redo.nil?
  	quiz.update(opt_can_rewind: @opt_can_rewind) unless @opt_can_rewind.nil?
  	quiz.update(opt_rand_question_order: @opt_rand_question_order) unless @opt_rand_question_order.nil?
  	quiz.update(opt_shared: @opt_shared) unless @opt_shared.nil?
  	# Mis à jour de update_at
  	quiz.update(updated_at: Time.now.to_s(:db))
  	quiz
  rescue => err
    raise_err err, "erreur lors de la mise à jour d'un quiz"
  end

  # Suppression d'un quiz
  def delete
  	quiz = Quizs[:id => @id]
  	quiz.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'un quiz"
  end	
end