# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'QuestionTest' do
  before(:each) do |example|
    @datas_bdd = generate_test_data(quizs: true, questions: true, suggestions: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:suggestions] )
      delete_test_data( @datas_bdd[:questions] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'Créer une nouvelle question dans la bdd' do
    params_new_question = {
      quiz_id: @datas_bdd[:quizs][0].id,
      type: 'TAT',
      question: 'Ma question numéro 2',
      order: 2,
      opt_rand_suggestion_order: true,
      hint: 'Petite aide pour la question'
    }
    my_question = Question.new(params_new_question)
    DB.transaction do
      id_my_question = my_question.create.id
      bdd_my_question = Questions[id: id_my_question]
      expect(bdd_my_question).to_not be_nil
      expect(bdd_my_question.quiz_id).to eq(@datas_bdd[:quizs][0].id)
      expect(bdd_my_question.type).to eq('TAT')
      expect(bdd_my_question.question).to eq('Ma question numéro 2')
      expect(bdd_my_question.order).to eq(2)
      expect(bdd_my_question.opt_rand_suggestion_order).to be_truthy
      expect(bdd_my_question.hint).to eq('Petite aide pour la question')
      expect(bdd_my_question.correction_comment).to be_nil
      expect(bdd_my_question.medium_id).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_question = Question.new
    expect { my_question.create }.to raise_error(RuntimeError)
  end

  it 'Récupère une question par son id' do
    found_question = Question.new({id: @datas_bdd[:questions][0].id})
    found_question = found_question.find
    expect(found_question).to_not be_nil
    expect(found_question.quiz_id).to eq(@datas_bdd[:quizs][0].id)
    expect(found_question.type).to eq('QCM')
    expect(found_question.question).to eq('Question numéro 0')
    expect(found_question.order).to eq(0)
    expect(found_question.opt_rand_suggestion_order).to be_falsey
    expect(found_question.hint).to eq('Aide pour la question numéro 0')
    expect(found_question.correction_comment).to eq('Commentaire pour la correction de la question 0')
    expect(found_question.medium_id).to be_nil
  end

  it 'La récupération ne retourne rien avec un id à nil' do
    found_question = Question.new
    expect(found_question.find).to be_nil
  end

  it "Retourne toutes les questions d'un quiz" do
    questions = Question.new({quiz_id: @datas_bdd[:quizs][0].id})
    questions = questions.find_all
    expect(questions.count).to eq(3)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    questions = Question.new(quiz_id: 'false_quiz_id')
    expect(questions.find_all).to be_empty
  end

  it "Met à jour les différentes données d'une question" do
    params_updated_question = {
      id: @datas_bdd[:questions][0].id,
      question: 'Question numéro 0 updated',
      hint: '',
      correction_comment: '',
      order: 2,
      opt_rand_suggestion_order: true
    }
    updated_question = Question.new(params_updated_question)
    DB.transaction do
      updated_question.update
      bdd_my_question_updated = Questions[id: @datas_bdd[:questions][0].id]
      expect(bdd_my_question_updated).to_not be_nil
      expect(bdd_my_question_updated.quiz_id).to eq(@datas_bdd[:quizs][0].id)
      expect(bdd_my_question_updated.type).to eq('QCM')
      expect(bdd_my_question_updated.question).to eq('Question numéro 0 updated')
      expect(bdd_my_question_updated.order).to eq(2)
      expect(bdd_my_question_updated.opt_rand_suggestion_order).to be_truthy
      expect(bdd_my_question_updated.hint).to be_empty
      expect(bdd_my_question_updated.correction_comment).to be_empty
      expect(bdd_my_question_updated.medium_id).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la mise à jour échoue' do
    params_updated_question = {
      id: nil,
      question: 'Question numéro 0 updated'
    }
    updated_question = Question.new(params_updated_question)
    expect { updated_question.update }.to raise_error(RuntimeError)
  end

  it 'Supprime une question par rapport à son id' do
    deleted_question = Question.new({id: @datas_bdd[:questions][0].id})
    DB.transaction do
      deleted_question.delete
      bdd_my_question_deleted = Questions[id: @datas_bdd[:questions][0].id]
      expect(bdd_my_question_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_question = Question.new
    expect { deleted_question.delete }.to raise_error(RuntimeError)
  end

  it 'Duplique les questions, ses suggestions et ses solutions' do
    DB.transaction do
      duplicated_questions = Question.new({quiz_id: @datas_bdd[:quizs][0].id})
      duplicated_questions.duplicate(@datas_bdd[:quizs][1].id)
      duplicated_questions_bdd = Questions.where(quiz_id: @datas_bdd[:quizs][1].id)
      expect(duplicated_questions_bdd.count).to eq(3)
      # On récupère les 3 type de question
      duplicated_question_QCM_bdd = duplicated_questions_bdd.where(type: 'QCM').first
      duplicated_question_ASS_bdd = duplicated_questions_bdd.where(type: 'ASS').first
      duplicated_question_TAT_bdd = duplicated_questions_bdd.where(type: 'TAT').first
      # On vérifie si on a bien dupliqué la question QCM
      expect(duplicated_question_QCM_bdd.question).to eq('Question numéro 0')
      expect(duplicated_question_QCM_bdd.order).to eq(0)
      expect(duplicated_question_QCM_bdd.opt_rand_suggestion_order).to be_falsey
      expect(duplicated_question_QCM_bdd.hint).to eq('Aide pour la question numéro 0')
      expect(duplicated_question_QCM_bdd.correction_comment).to eq('Commentaire pour la correction de la question 0')
      # On vérifie si on a bien dupliqué la question ASS
      expect(duplicated_question_ASS_bdd.question).to eq('Question numéro 1')
      expect(duplicated_question_ASS_bdd.order).to eq(1)
      expect(duplicated_question_ASS_bdd.opt_rand_suggestion_order).to be_truthy
      expect(duplicated_question_ASS_bdd.hint).to eq('Aide pour la question numéro 1')
      expect(duplicated_question_ASS_bdd.correction_comment).to eq('Commentaire pour la correction de la question 1')
      # On vérifie si on a bien dupliqué la question TAT
      expect(duplicated_question_TAT_bdd.question).to eq('Question numéro 2')
      expect(duplicated_question_TAT_bdd.order).to eq(2)
      expect(duplicated_question_TAT_bdd.opt_rand_suggestion_order).to be_truthy
      expect(duplicated_question_TAT_bdd.hint).to eq('Aide pour la question numéro 2')
      expect(duplicated_question_TAT_bdd.correction_comment).to eq('Commentaire pour la correction de la question 2')
      # On vérifie que l'on a bien dupliqué les suggestions
      # QCM
      duplicated_suggestions_QCM_bdd = Suggestions.where(question_id: duplicated_question_QCM_bdd.id)
      expect(duplicated_suggestions_QCM_bdd.count).to eq(2)
      # ASS
      duplicated_suggestions_ASS_bdd = Suggestions.where(question_id: duplicated_question_ASS_bdd.id)
      expect(duplicated_suggestions_ASS_bdd.count).to eq(3)
      # TAT
      duplicated_suggestions_TAT_bdd = Suggestions.where(question_id: duplicated_question_TAT_bdd.id)
      expect(duplicated_suggestions_TAT_bdd.count).to eq(3)
      fail Sequel::Rollback
    end
  end
end
