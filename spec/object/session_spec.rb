# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'SessionTest' do
  before(:each) do |example|
    @datas_bdd = generate_test_data({quizs: true, questions: true, suggestions: true, publications: true, sessions: true}) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:sessions] )
      delete_test_data( @datas_bdd[:publications] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'Créer une nouvelle session dans la bdd' do
    params_new_session = {
      quiz_id: @datas_bdd[:quizs][0].id,
      user_id: 'VAA60002',
      user_type: 'ENS',
      score: 0
    }
    my_session = Session.new(params_new_session)
    DB.transaction do
      id_my_session = my_session.create.id
      bdd_my_session = Sessions[id: id_my_session]
      expect(bdd_my_session).to_not be_nil
      expect(bdd_my_session.created_at).to_not be_nil
      expect(bdd_my_session.updated_at).to_not be_nil
      expect(bdd_my_session.quiz_id).to eq(@datas_bdd[:quizs][0].id )
      expect(bdd_my_session.user_id).to eq('VAA60002')
      expect(bdd_my_session.user_type).to eq('ENS')
      expect(bdd_my_session.score).to eq(0)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_session = Session.new
    expect { my_session.create }.to raise_error(RuntimeError)
  end

  it 'Récupère une session par son id' do
    found_session = Session.new({id: @datas_bdd[:sessions][0].id})
    found_session = found_session.find
    expect(found_session).to_not be_nil
    expect(found_session.created_at).to_not be_nil
    expect(found_session.updated_at).to be_nil
    expect(found_session.quiz_id).to eq(@datas_bdd[:quizs][0].id)
    expect(found_session.user_id).to eq('VAA60000')
    expect(found_session.user_type).to eq('ENS')
    expect(found_session.score).to eq(0)
  end

  it 'La récupération ne retourne rien avec un id à nil' do
    found_session = Session.new
    expect(found_session.find).to be_nil
  end

  it "Retourne toutes les sessions d'un quiz" do
    sessions_quiz = Session.new({quiz_id: @datas_bdd[:quizs][0].id})
    sessions_quiz = sessions_quiz.find_all
    expect(sessions_quiz.count).to eq(2)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    sessions_quiz = Session.new({quiz_id: 'false_user_id'})
    expect(sessions_quiz.find_all).to be_empty
  end

  it "Met à jour le score d'une session" do
    params_updated_session = {
      id: @datas_bdd[:sessions][0].id,
      score: 18
    }
    updated_session = Session.new(params_updated_session)
    DB.transaction do
      updated_session.update
      bdd_my_session_updated = Sessions[id: @datas_bdd[:sessions][0].id]
      expect(bdd_my_session_updated).to_not be_nil
      expect(bdd_my_session_updated.created_at).to_not be_nil
      expect(bdd_my_session_updated.updated_at).to_not be_nil
      expect(bdd_my_session_updated.quiz_id).to eq(@datas_bdd[:quizs][0].id )
      expect(bdd_my_session_updated.user_id).to eq('VAA60000')
      expect(bdd_my_session_updated.user_type).to eq('ENS')
      expect(bdd_my_session_updated.score).to eq(18)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la mise à jour échoue' do
    params_updated_session = {
      id: nil,
      score: 18
    }
    updated_session = Session.new(params_updated_session)
    expect { updated_session.update }.to raise_error(RuntimeError)
  end

  it 'Supprime une session par rapport à son id' do
    deleted_session = Session.new({id: @datas_bdd[:sessions][0].id})
    DB.transaction do
      deleted_session.delete
      bdd_my_session_deleted = Sessions[id: @datas_bdd[:sessions][0].id]
      expect(bdd_my_session_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_session = Session.new
    expect { deleted_session.delete }.to raise_error(RuntimeError)
  end

  it "récupère les sessions des élèves d'un quiz" do
    sessions_elv_quiz = Session.new({user_id: MOCKED_DATA[:uid]})
    sessions_elv_quiz = sessions_elv_quiz.find_all_elv_of_prof([@datas_bdd[:quizs][0].id])
    expect(sessions_elv_quiz.count).to eq(1)
    expect(sessions_elv_quiz.first.user_id).to eq('VAA60001')
    expect(sessions_elv_quiz.first.user_type).to eq('ELV')
    expect(sessions_elv_quiz.first.score).to eq(15)
  end
end
