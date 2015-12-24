# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibAnswersTest' do
  before(:each) do |example|
    Lib::Answers.user( MOCKED_DATA ) unless example.metadata[:skip_before_user]
    @datas_bdd = generate_test_data(quizs: true, questions: true, suggestions: true, solutions: true, sessions: true, answers: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    Lib::Answers.user(nil)
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:answers] )
      delete_test_data( @datas_bdd[:sessions] )
      delete_test_data( @datas_bdd[:solutions] )
      delete_test_data( @datas_bdd[:suggestions] )
      delete_test_data( @datas_bdd[:questions] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it "enregiste les reponses d'une question QCM et calcule le score" do
    DB.transaction do
      JSON_CREATE_ANSWER_QCM[:quiz_id] = @datas_bdd[:quizs][0].id
      JSON_CREATE_ANSWER_QCM[:session_id] = @datas_bdd[:sessions][0].id
      JSON_CREATE_ANSWER_QCM[:question][:id] = @datas_bdd[:questions][0].id
      JSON_CREATE_ANSWER_QCM[:question][:answers][0][:id] = @datas_bdd[:suggestions][1].id
      result = Lib::Answers.create(JSON_CREATE_ANSWER_QCM)
      old_answer = Answers[id: @datas_bdd[:answers][0].id]
      session = Sessions[id: @datas_bdd[:sessions][0].id]
      expect(result[:error]).to be_nil
      # la reponse qui existait déjà pour cette question de la même session est supprimée
      expect(old_answer).to be_nil
      expect(result[:answers_created][0][:session_id]).to eq(@datas_bdd[:sessions][0].id)
      expect(result[:answers_created][0][:left_suggestion_id]).to eq(@datas_bdd[:suggestions][1].id)
      expect(session.score).to eq(0)
      fail Sequel::Rollback
    end
  end

  it "enregiste les reponses d'une question ASS et calcule le score" do
    DB.transaction do
      JSON_CREATE_ANSWER_ASS[:quiz_id] = @datas_bdd[:quizs][0].id
      JSON_CREATE_ANSWER_ASS[:session_id] = @datas_bdd[:sessions][0].id
      JSON_CREATE_ANSWER_ASS[:question][:id] = @datas_bdd[:questions][1].id
      JSON_CREATE_ANSWER_ASS[:question][:answers][0][:leftProposition][:id] = @datas_bdd[:suggestions][2].id
      JSON_CREATE_ANSWER_ASS[:question][:answers][0][:leftProposition][:solutions] = [0]
      JSON_CREATE_ANSWER_ASS[:question][:answers][0][:rightProposition][:id] = @datas_bdd[:suggestions][3].id
      JSON_CREATE_ANSWER_ASS[:question][:answers][0][:rightProposition][:solutions] = [0]
      result = Lib::Answers.create(JSON_CREATE_ANSWER_ASS)
      session = Sessions[id: @datas_bdd[:sessions][0].id]
      expect(result[:error]).to be_nil
      # la reponse qui existait déjà pour cette question de la même session est supprimée
      expect(result[:answers_created][0][:session_id]).to eq(@datas_bdd[:sessions][0].id)
      expect(result[:answers_created][0][:left_suggestion_id]).to eq(@datas_bdd[:suggestions][2].id)
      expect(result[:answers_created][0][:right_suggestion_id]).to eq(@datas_bdd[:suggestions][3].id)
      expect(session.score).to eq(33.3)
      fail Sequel::Rollback
    end
  end
end
