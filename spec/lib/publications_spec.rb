# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibPublicationsTest' do
  before(:each) do |example|
    Lib::Publications.user( MOCKED_DATA ) unless example.metadata[:skip_before_user]
    @datas_bdd = generate_test_data(quizs: true, publications: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    Lib::Answers.user(nil)
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:publications] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it "Récupère les poublications d'un quiz" do
    results = Lib::Publications.get_all(@datas_bdd[:quizs][0].id)
    expect(results[:publications_found].size).to eq(1)
    expect(results[:publications_found][0][:rgptId]).to eq(1)
    expect(results[:publications_found][0][:name]).to eq('6B')
    expect(results[:publications_found][0][:nameEtab]).to eq("CLG-VAL D'ARGENT")
  end

  it 'ajoute une publication à un quiz' do
    params = {
      quiz_id: @datas_bdd[:quizs][0].id,
      added: [
        {
          id: 609
        }
      ],
      fromDate: nil,
      toDate: nil
    }
    DB.transaction do
      results = Lib::Publications.add(params)
      publication_bdd = Publications[quiz_id: @datas_bdd[:quizs][0].id, rgpt_id: 609]
      expect(publication_bdd).to_not be_nil
      expect(publication_bdd.rgpt_id).to eq(609)
      fail Sequel::Rollback
    end
  end

  it 'supprime une publication' do
    DB.transaction do
      results = Lib::Publications.delete([{id: @datas_bdd[:publications][0].id}])
      publication_bdd = Publications[id: @datas_bdd[:publications][0].id]
      expect(publication_bdd).to be_nil
      fail Sequel::Rollback
    end
  end
end
