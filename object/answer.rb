# -*- coding: utf-8 -*-

# Objet answer permettant de faire le lien avec la BDD
class Answer
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# session_id Integer
	# left_suggestion_id Integer 
	# Paramètres facultatifs
	# right_suggestion_id Integer
	# created_at DateTime
	def initialize ( params = {} )
		@id = params[:id]
		@session_id = params[:session_id]
		@left_suggestion_id = params[:left_suggestion_id]
		@right_suggestion_id = params[:right_suggestion_id]
		@created_at = Time.now.to_s(:db)
	end

	# Création d'une réponse
	def create
		answer = Answers.new
		answer.session_id = @session_id
		answer.left_suggestion_id = @left_suggestion_id
		answer.right_suggestion_id = @right_suggestion_id
		answer.created_at = @created_at
		# On enregistre la réponse
		answer.save
		@id = answer.id
		answer
	rescue => err
    raise_err err, "erreur lors de la création d'une réponse"
  end

  # Récupération d'une réponse par rapport à son id
  def find
  	Answers[:id => @id]
  end

  # Récupération d'une liste de réponses par rapport à
  # sesison_id Integer
  def find_all
  	answers = []
  	# Récupération des publications d'un quiz
  	answers = Answers.where(:session_id => @session_id) unless @session_id.nil?
  	answers
  end

  # Récupère les réponses d'une session pour une question
  def find_all_session_question(question_id)
  	# on récupère toutes les suggestions de gauche d'une question
  	suggestions = Suggestions.where(:question_id => question_id, :position => 'L').select(:id)
  	# on récupère maintenant les réponses de la sessions 
  	# dont leur id est inclu dans la liste des suggestions de la question
  	Answers.where(:session_id => @session_id, :left_suggestion_id => suggestions)
  end

  # Suppression d'une réponse
  def delete
  	answer = Answers[:id => @id]
  	answer.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une réponse"
  end	
end