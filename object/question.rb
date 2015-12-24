# -*- coding: utf-8 -*-

# Objet question permettant de faire le lien avec la BDD
class Question
  include Outils

  # Initialise l'objet avec les paramètres suivant
  # Paramètres obligatoires
  # id auto_increment
  # quiz_id String
  # type Enum('QCM', 'TAT', 'ASS')
  # question String
  # order Integer
  # opt_rand_suggestion_order Boolean
  # Paramètres facultatifs
  # hint String
  # correction_comment String
  # medium_id Integer
  def initialize( params = {} )
    @id = params[:id]
    @quiz_id = params[:quiz_id]
    @type = params[:type]
    @question = params[:question]
    @order = params[:order]
    @opt_rand_suggestion_order = params[:opt_rand_suggestion_order]
    @hint = params[:hint]
    @correction_comment = params[:correction_comment]
    @medium_id = params[:medium_id]
  end

  # Création d'une question
  def create
    question = Questions.new
    question.quiz_id = @quiz_id
    question.type = @type
    question.question = @question
    question.order = @order
    question.opt_rand_suggestion_order = @opt_rand_suggestion_order
    question.hint = @hint
    question.correction_comment = @correction_comment
    question.medium_id = @medium_id
    # On enregistre la question
    question.save
    # on récupère l'id auto généré
    @id = question.id
    question
  rescue => err
    raise_err err, "erreur lors de la création d'une question"
  end

  # Récupération d'une question par rapport à son id
  def find
    Questions[id: @id]
  end

  # Récupération d'une liste de questions par rapport à
  # quiz_id Integer
  def find_all
    questions = []
    # Récupération des questions d'un quiz
    questions = Questions.where(quiz_id: @quiz_id) unless @quiz_id.nil?
    questions
  end

  # Mise à jour des données d'une question
  # id Integer permet de récupérer la question
  # question String
  # hint String
  # correction_comment String
  # order Integer
  # medium_id Integer
  # opt_rand_suggestion_order Boolean
  def update
    question = Questions[id: @id]
    question.update(question: @question) unless @question.nil?
    question.update(hint: @hint) unless @hint.nil?
    question.update(correction_comment: @correction_comment) unless @correction_comment.nil?
    question.update(order: @order) unless @order.nil?
    question.update(medium_id: @medium_id) unless @medium_id.nil?
    question.update(opt_rand_suggestion_order: @opt_rand_suggestion_order) unless @opt_rand_suggestion_order.nil?
    question
  rescue => err
    raise_err err, "erreur lors de la mise à jour d'une question"
  end

  # Suppression d'une question
  def delete
    question = Questions[id: @id]
    question.delete
  rescue => err
    raise_err err, "erreur lors de la suppression d'une question"
  end

  # Clonage des questions
  def duplicate(new_quiz_id)
    questions = find_all
    questions.each do |question_source|
      @quiz_id = new_quiz_id
      @type = question_source.type
      @question = question_source.question
      @order = question_source.order
      @opt_rand_suggestion_order = question_source.opt_rand_suggestion_order
      @hint = question_source.hint
      @correction_comment = question_source.correction_comment
      @medium_id = question_source.medium_id
      new_question = create
      case @type
      when 'QCM'
        suggestions = SuggestionQCM.new(question_id: question_source.id)
      when 'TAT'
        suggestions = SuggestionTAT.new(question_id: question_source.id)
      when 'ASS'
        suggestions = SuggestionASS.new(question_id: question_source.id)
      end
      suggestions.duplicate(new_question.id)
    end
  rescue => err
    raise_err err, "erreur lors du clonage d'une question"
  end
end
