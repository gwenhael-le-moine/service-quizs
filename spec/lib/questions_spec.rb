# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibQuestionsTest' do
	before(:each) do |example|
    Lib::Questions.user( MOCKED_DATA ) unless example.metadata[:skip_before_user]
		@datas_bdd = generate_test_data({quizs: true, questions: true, suggestions: true, solutions: true}) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    Lib::Questions.user(nil)
  	unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:solutions] )
      delete_test_data( @datas_bdd[:suggestions] )
    	delete_test_data( @datas_bdd[:questions] ) 
  		delete_test_data( @datas_bdd[:quizs] )
  	end
  end

  it "Retourne une question QCM et ses réponses" do
    result = Lib::Questions.get(@datas_bdd[:questions][0].id)
    expect(result[:question_found][:type]).to eq('qcm')
    expect(result[:question_found][:libelle]).to eq('Question numéro 0')
    expect(result[:question_found][:hint][:libelle]).to eq('Aide pour la question numéro 0')
    expect(result[:question_found][:answers].size).to eq(8)
    expect(result[:question_found][:answers][0][:id]).to eq(@datas_bdd[:suggestions][0].id)
    expect(result[:question_found][:answers][0][:proposition]).to eq("Suggestion numéro 0 de la question")
    expect(result[:question_found][:answers][0][:solution]).to be_truthy
    expect(result[:question_found][:answers][1][:id]).to eq(@datas_bdd[:suggestions][1].id)
    expect(result[:question_found][:answers][1][:proposition]).to eq("Suggestion numéro 1 de la question")
    expect(result[:question_found][:answers][1][:solution]).to be_falsey
  end

  it "Retourne toutes les questions d'un quiz" do
    result = Lib::Questions.get_all(@datas_bdd[:quizs][0].id)
    expect(result[:questions_found].size).to eq(3)
    expect(result[:questions_found][0][:id]).to eq(@datas_bdd[:questions][0].id)
    expect(result[:questions_found][0][:type]).to eq("QCM")
    expect(result[:questions_found][0][:libelle]).to eq("Question numéro 0")
    expect(result[:questions_found][1][:id]).to eq(@datas_bdd[:questions][1].id)
    expect(result[:questions_found][1][:type]).to eq("ASS")
    expect(result[:questions_found][1][:libelle]).to eq("Question numéro 1")
    expect(result[:questions_found][2][:id]).to eq(@datas_bdd[:questions][2].id)
    expect(result[:questions_found][2][:type]).to eq("TAT")
    expect(result[:questions_found][2][:libelle]).to eq("Question numéro 2")
  end

  it "Créé une nouvelle question qcm" do
    JSON_CREATE_QUESTION_QCM[:id] = @datas_bdd[:quizs][0][:id]
    JSON_CREATE_QUESTION_QCM[:created_at] = @datas_bdd[:quizs][0][:created_at]
    JSON_CREATE_QUESTION_QCM[:updated_at] = @datas_bdd[:quizs][0][:updated_at]
    DB.transaction do
      result = Lib::Questions.create(JSON_CREATE_QUESTION_QCM)
      bdd_question_created = Questions[:id => result[:question_created][:id]]
      bdd_suggestion_1 = Suggestions[:id => result[:question_created][:answers][0][:id]]
      bdd_suggestion_2 = Suggestions[:id => result[:question_created][:answers][1][:id]]
      bdd_suggestion_2_solution = Solutions[:left_suggestion_id => result[:question_created][:answers][1][:id]]
      expect(bdd_question_created.type).to eq("QCM")
      expect(bdd_question_created.question).to eq("Création d'une questions de test type qcm")
      expect(bdd_question_created.hint).to eq("Aide de la questions qcm")
      expect(bdd_suggestion_1.text).to eq("Proposition 1 qcm")
      expect(bdd_suggestion_1.order).to eq(0)
      expect(bdd_suggestion_1.position).to eq("L")
      expect(bdd_suggestion_2.text).to eq("Proposition 2 solution qcm")
      expect(bdd_suggestion_2.order).to eq(1)
      expect(bdd_suggestion_2.position).to eq("L")
      expect(bdd_suggestion_2_solution).to_not be_nil
      raise Sequel::Rollback
    end
  end

  it "Créé une nouvelle question tat" do
    JSON_CREATE_QUESTION_TAT[:id] = @datas_bdd[:quizs][0][:id]
    JSON_CREATE_QUESTION_TAT[:created_at] = @datas_bdd[:quizs][0][:created_at]
    JSON_CREATE_QUESTION_TAT[:updated_at] = @datas_bdd[:quizs][0][:updated_at]
    DB.transaction do
      result = Lib::Questions.create(JSON_CREATE_QUESTION_TAT)
      bdd_question_created = Questions[:id => result[:question_created][:id]]
      bdd_suggestion_1 = Suggestions[:id => result[:question_created][:answers][0][:id]]
      bdd_suggestion_2 = Suggestions[:id => result[:question_created][:answers][0][:solution][:id]]
      bdd_suggestion_1_2_solution = Solutions[:left_suggestion_id => bdd_suggestion_1.id, :right_suggestion_id => bdd_suggestion_2.id]
      bdd_suggestion_3 = Suggestions[:id => result[:question_created][:answers][1][:id]]
      bdd_leurre_1 = Suggestions[:id => result[:question_created][:leurres][0][:id]]
      bdd_leurre_2 = Suggestions[:id => result[:question_created][:leurres][1][:id]]
      expect(bdd_question_created.type).to eq("TAT")
      expect(bdd_question_created.question).to eq("Création d'une question de test type texte à trous")
      expect(bdd_question_created.hint).to be_nil
      expect(bdd_suggestion_1.text).to eq("un test est une procédure de")
      expect(bdd_suggestion_1.order).to be_nil
      expect(bdd_suggestion_1.position).to eq("L")
      expect(bdd_suggestion_2.text).to eq("vérification")
      expect(bdd_suggestion_2.position).to eq("R")
      expect(bdd_suggestion_1_2_solution).to_not be_nil
      expect(bdd_suggestion_3.text).to eq("Il permet de verifier les problèmes du logiciel.")
      expect(bdd_suggestion_3.position).to eq("L")
      expect(bdd_leurre_1.text).to eq("transformation")
      expect(bdd_leurre_1.position).to eq("R")
      expect(bdd_leurre_2.text).to eq("personnalisation")
      expect(bdd_leurre_2.position).to eq("R")
      raise Sequel::Rollback
    end
  end

  it "Créé une nouvelle question ass" do
    JSON_CREATE_QUESTION_ASS[:id] = @datas_bdd[:quizs][0][:id]
    JSON_CREATE_QUESTION_ASS[:created_at] = @datas_bdd[:quizs][0][:created_at]
    JSON_CREATE_QUESTION_ASS[:updated_at] = @datas_bdd[:quizs][0][:updated_at]
    DB.transaction do
      result = Lib::Questions.create(JSON_CREATE_QUESTION_ASS)
      bdd_question_created = Questions[:id => result[:question_created][:id]]
      # Récupération des suggestions
      bdd_left_suggestion_1 = Suggestions[:id => result[:question_created][:answers][0][:leftProposition][:id]]
      bdd_right_suggestion_1 = Suggestions[:id => result[:question_created][:answers][0][:rightProposition][:id]]
      bdd_left_suggestion_2 = Suggestions[:id => result[:question_created][:answers][1][:leftProposition][:id]]
      bdd_right_suggestion_2 = Suggestions[:id => result[:question_created][:answers][1][:rightProposition][:id]]
      bdd_left_suggestion_3 = Suggestions[:id => result[:question_created][:answers][2][:leftProposition][:id]]
      bdd_right_suggestion_3 = Suggestions[:id => result[:question_created][:answers][2][:rightProposition][:id]]
      bdd_right_suggestion_4 = Suggestions[:id => result[:question_created][:answers][3][:rightProposition][:id]]
      # Récupération des 3 solutions
      bdd_2_1_solution = Solutions[:left_suggestion_id => bdd_left_suggestion_2.id, :right_suggestion_id => bdd_right_suggestion_1.id]
      bdd_2_2_solution = Solutions[:left_suggestion_id => bdd_left_suggestion_2.id, :right_suggestion_id => bdd_right_suggestion_2.id]
      bdd_3_3_solution = Solutions[:left_suggestion_id => bdd_left_suggestion_3.id, :right_suggestion_id => bdd_right_suggestion_3.id]

      expect(bdd_question_created.type).to eq("ASS")
      expect(bdd_question_created.question).to eq("Création d'une questions de test type association")
      expect(bdd_question_created.hint).to eq("Aide de la questions association")

      expect(bdd_left_suggestion_1.text).to eq("Proposition L ASS 1")
      expect(bdd_left_suggestion_1.order).to eq(0)
      expect(bdd_left_suggestion_1.position).to eq("L")
      expect(bdd_right_suggestion_1.text).to eq("Proposition R ASS 1")
      expect(bdd_right_suggestion_1.order).to eq(0)
      expect(bdd_right_suggestion_1.position).to eq("R")
      expect(bdd_left_suggestion_2.text).to eq("Proposition L ASS 2")
      expect(bdd_left_suggestion_2.order).to eq(1)
      expect(bdd_left_suggestion_2.position).to eq("L")
      expect(bdd_right_suggestion_2.text).to eq("Proposition R ASS 2")
      expect(bdd_right_suggestion_2.order).to eq(1)
      expect(bdd_right_suggestion_2.position).to eq("R")

      expect(bdd_2_1_solution).to_not be_nil
      expect(bdd_2_2_solution).to_not be_nil
      expect(bdd_3_3_solution).to_not be_nil
      raise Sequel::Rollback
    end
  end

  it "met à jour une question qcm" do
    json_update_qcm = json_update_question_qcm(@datas_bdd[:quizs][0], @datas_bdd[:questions][0], @datas_bdd[:suggestions])
    DB.transaction do
      result = Lib::Questions.update(json_update_qcm)
      bdd_question_updated = Questions[:id => result[:question_updated][:id]]
      bdd_suggestion_1 = Suggestions[:id => result[:question_updated][:answers][0][:id]]
      bdd_suggestion_2 = Suggestions[:id => result[:question_updated][:answers][1][:id]]
      bdd_suggestion_2_solution = Solutions[:left_suggestion_id => result[:question_updated][:answers][1][:id]]
      expect(bdd_question_updated.type).to eq("QCM")
      expect(bdd_question_updated.question).to eq("libellé de la question mis à jour")
      expect(bdd_question_updated.hint).to eq("aide de la question mise à jour")
      expect(bdd_suggestion_1.text).to eq("proposition 0 updated")
      expect(bdd_suggestion_1.position).to eq("L")
      expect(bdd_suggestion_2.text).to eq("proposition 1 updated")
      expect(bdd_suggestion_2.position).to eq("L")
      expect(bdd_suggestion_2_solution).to_not be_nil
      raise Sequel::Rollback
    end
  end

  it "met à jour une question tat" do
    json_update_tat = json_update_question_tat(@datas_bdd[:quizs][0], @datas_bdd[:questions][2], @datas_bdd[:suggestions])
    DB.transaction do
      result = Lib::Questions.update(json_update_tat)
      bdd_question_updated = Questions[:id => result[:question_updated][:id]]
      bdd_suggestion_1 = Suggestions[:id => result[:question_updated][:answers][0][:id]]
      bdd_suggestion_2 = Suggestions[:id => result[:question_updated][:answers][0][:solution][:id]]
      bdd_suggestion_1_2_solution = Solutions[:left_suggestion_id => bdd_suggestion_1.id, :right_suggestion_id => bdd_suggestion_2.id]
      bdd_old_leurre = Suggestions[:id => @datas_bdd[:suggestions][7].id]
      expect(bdd_question_updated.type).to eq("TAT")
      expect(bdd_question_updated.question).to eq("libellé de la question mis à jour")
      expect(bdd_question_updated.hint).to eq("aide de la question mise à jour")
      expect(bdd_suggestion_1.text).to eq("texte mis à jour")
      expect(bdd_suggestion_1.position).to eq("L")
      expect(bdd_suggestion_2.text).to eq("solution mise à jour")
      expect(bdd_suggestion_2.position).to eq("R")
      expect(bdd_old_leurre).to be_nil
      raise Sequel::Rollback
    end
  end

  it "met à jour une question ass" do
    json_update_ass = json_update_question_ass(@datas_bdd[:quizs][0], @datas_bdd[:questions][1], @datas_bdd[:suggestions])
    DB.transaction do
      result = Lib::Questions.update(json_update_ass)
      bdd_question_updated = Questions[:id => result[:question_updated][:id]]
      # Récupération des suggestions
      bdd_left_suggestion_1 = Suggestions[:id => result[:question_updated][:answers][0][:leftProposition][:id]]
      bdd_right_suggestion_1 = Suggestions[:id => result[:question_updated][:answers][0][:rightProposition][:id]]
      bdd_left_suggestion_2 = Suggestions[:id => result[:question_updated][:answers][1][:leftProposition][:id]]
      # Récupération de la solution
      bdd_2_1_solution = Solutions[:left_suggestion_id => bdd_left_suggestion_2.id, :right_suggestion_id => bdd_right_suggestion_1.id]
      expect(bdd_question_updated.type).to eq("ASS")
       expect(bdd_question_updated.question).to eq("libellé de la question mis à jour")
      expect(bdd_question_updated.hint).to eq("aide de la question mise à jour")

      expect(bdd_left_suggestion_1.text).to eq("libelle proposition gauche mis à jour")
      expect(bdd_left_suggestion_1.order).to eq(0)
      expect(bdd_left_suggestion_1.position).to eq("L")
      expect(bdd_right_suggestion_1.text).to eq("libelle proposition droite mis à jour")
      expect(bdd_right_suggestion_1.order).to eq(0)
      expect(bdd_right_suggestion_1.position).to eq("R")
      expect(bdd_left_suggestion_2.text).to eq("libelle proposition gauche mis à jour")
      expect(bdd_left_suggestion_2.order).to eq(1)
      expect(bdd_left_suggestion_2.position).to eq("L")

      expect(bdd_2_1_solution).to_not be_nil
      raise Sequel::Rollback
    end
  end

  it "met à jour l'ordre des questions" do
    JSON_UPDATE_ORDER_QUESTIONS[:id] = @datas_bdd[:quizs][0][:id]
    JSON_UPDATE_ORDER_QUESTIONS[:questions][0][:id] = @datas_bdd[:questions][2][:id]
    JSON_UPDATE_ORDER_QUESTIONS[:questions][1][:id] = @datas_bdd[:questions][1][:id]
    JSON_UPDATE_ORDER_QUESTIONS[:questions][2][:id] = @datas_bdd[:questions][0][:id]
    DB.transaction do
      Lib::Questions.update_order(JSON_UPDATE_ORDER_QUESTIONS)
      question_tat = Questions[:id => @datas_bdd[:questions][2][:id]]
      question_ass = Questions[:id => @datas_bdd[:questions][1][:id]]
      question_qcm = Questions[:id => @datas_bdd[:questions][0][:id]]
      expect(question_tat.order).to eq(0)
      expect(question_ass.order).to eq(1)
      expect(question_qcm.order).to eq(2)
      raise Sequel::Rollback
    end
  end

  it "Supprime une question QCM" do
    DB.transaction do
      Lib::Questions.delete(@datas_bdd[:questions][0][:id])
      deleted_qcm_question = Questions[:id => @datas_bdd[:questions][0][:id]]
      expect(deleted_qcm_question).to be_nil
      raise Sequel::Rollback
    end
  end

  it "Supprime une question ASS" do
    DB.transaction do
      Lib::Questions.delete(@datas_bdd[:questions][1][:id])
      deleted_ass_question = Questions[:id => @datas_bdd[:questions][1][:id]]
      expect(deleted_ass_question).to be_nil
      raise Sequel::Rollback
    end
  end

  it "Supprime une question TAT" do
    DB.transaction do
      Lib::Questions.delete(@datas_bdd[:questions][2][:id])
      deleted_tat_question = Questions[:id => @datas_bdd[:questions][2][:id]]
      expect(deleted_tat_question).to be_nil
      raise Sequel::Rollback
    end
  end
end