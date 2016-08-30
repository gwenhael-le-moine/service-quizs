# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibSessionsTest' do
  before(:each) do |example|
    Lib::Sessions.user( MOCKED_DATA ) unless example.metadata[:skip_before_user]
    @datas_bdd = generate_test_data(quizs: true, publications: true, sessions: true) unless example.metadata[:skip_before]
  end
  after(:each) do |example|
    Lib::Sessions.user(nil)
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:sessions] )
      delete_test_data( @datas_bdd[:publications] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'créé une session' do
    DB.transaction do
      result = Lib::Sessions.create(@datas_bdd[:quizs][0].id)
      bdd_session_created = Sessions[id: result[:session_created][:id]]
      expect(bdd_session_created.quiz_id).to eq(@datas_bdd[:quizs][0].id)
      expect(bdd_session_created.user_id).to eq('VAA60000')
      expect(bdd_session_created.user_type).to eq('ENS')
      expect(bdd_session_created.score).to eq(0)
      fail Sequel::Rollback
    end
  end

  it 'récupère une session' do
    DB.transaction do
      result = Lib::Sessions.get(@datas_bdd[:sessions][0].id)
      bdd_session_found = Sessions[id: result[:session_found][:id]]
      expect(bdd_session_found.quiz_id).to eq(@datas_bdd[:quizs][0].id)
      expect(bdd_session_found.user_id).to eq('VAA60000')
      expect(bdd_session_found.user_type).to eq('ENS')
      expect(bdd_session_found.score).to eq(0)
      fail Sequel::Rollback
    end
  end

  it 'vérifie si au moins une session exist' do
    DB.transaction do
      result = Lib::Sessions.exist?(@datas_bdd[:quizs][0].id)
      expect(result[:exist]).to be_truthy
      fail Sequel::Rollback
    end
  end

  it 'supprime les sessions' do
    DB.transaction do
      ids = @datas_bdd[:sessions][0..1].map(&:id)
      results = Lib::Sessions.delete(ids)
      session_bdd_0 = Sessions[id: @datas_bdd[:sessions][0].id]
      session_bdd_1 = Sessions[id: @datas_bdd[:sessions][1].id]
      expect(session_bdd_0).to be_nil
      expect(session_bdd_1).to be_nil
      expect(results[:sessions_deleted].size).to eq(2)
      fail Sequel::Rollback
    end
  end
end
