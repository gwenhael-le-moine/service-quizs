# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'AnswerTest' do
  before(:each) do |example|
    @datas_bdd = generate_test_data(quizs: true, questions: true, suggestions: true, publications: true, sessions: true, answers: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:answers] )
      delete_test_data( @datas_bdd[:sessions] )
      delete_test_data( @datas_bdd[:suggestions] )
      delete_test_data( @datas_bdd[:questions] )
      delete_test_data( @datas_bdd[:publications] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'Créer une nouvelle réponse dans la bdd' do
    params_new_answer = {
      session_id: @datas_bdd[:sessions][1].id,
      left_suggestion_id: @datas_bdd[:suggestions][1].id
    }
    my_answer = Answer.new(params_new_answer)
    DB.transaction do
      id_my_answer = my_answer.create.id
      bdd_my_answer = Answers[id: id_my_answer]
      expect(bdd_my_answer).to_not be_nil
      expect(bdd_my_answer.created_at).to_not be_nil
      expect(bdd_my_answer.session_id).to eq(@datas_bdd[:sessions][1].id)
      expect(bdd_my_answer.left_suggestion_id).to eq(@datas_bdd[:suggestions][1].id )
      expect(bdd_my_answer.right_suggestion_id).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_answer = Answer.new
    expect { my_answer.create }.to raise_error(RuntimeError)
  end

  it 'Récupère une réponse par son id' do
    found_answer = Answer.new(id: @datas_bdd[:answers][0].id)
    found_answer = found_answer.find
    expect(found_answer).to_not be_nil
    expect(found_answer.created_at).to_not be_nil
    expect(found_answer.session_id).to eq(@datas_bdd[:sessions][0].id)
    expect(found_answer.left_suggestion_id).to eq(@datas_bdd[:suggestions][0].id)
    expect(found_answer.right_suggestion_id).to be_nil
  end

  it 'La récupération ne retourne rien avec un id à nil' do
    found_answer = Answer.new
    expect(found_answer.find).to be_nil
  end

  it "Retourne toutes les réponses d'une session" do
    answers_session = Answer.new(session_id: @datas_bdd[:sessions][0].id)
    answers_session = answers_session.find_all
    expect(answers_session.count).to eq(1)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    answers_session = Answer.new(session_id: 'false_user_id')
    expect(answers_session.find_all).to be_empty
  end

  it "Récupère toutes les réponses d'une session pour une question" do
    answers_session_question = Answer.new(session_id: @datas_bdd[:sessions][0].id)
    answers_session_question = answers_session_question.find_all_session_question(@datas_bdd[:questions][0].id)
    expect(answers_session_question.count).to eq(1)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    answers_session_question = Answer.new(session_id: 'false_id')
    expect(answers_session_question.find_all_session_question(@datas_bdd[:questions][0].id)).to be_empty
  end

  it 'Supprime une réponse par rapport à son id' do
    deleted_answer = Answer.new(id: @datas_bdd[:answers][0].id)
    DB.transaction do
      deleted_answer.delete
      bdd_my_answer_deleted = Answers[id: @datas_bdd[:answers][0].id]
      expect(bdd_my_answer_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_answer = Answer.new
    expect { deleted_answer.delete }.to raise_error(RuntimeError)
  end

  it "Retourne les reponses d'une session pour une question" do
    answers = Answer.new(session_id: @datas_bdd[:sessions][0].id)
    answers = answers.find_all_session_question(@datas_bdd[:questions][0].id)
    expect(answers.count).to eq(1)
  end
end
