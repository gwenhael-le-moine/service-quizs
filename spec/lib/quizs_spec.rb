# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibQuizsTest' do
  before(:each) do |example|
    Lib::Quizs.user( MOCKED_DATA ) unless example.metadata[:skip_before_user]
    @datas_bdd = generate_test_data(quizs: true) unless example.metadata[:skip_before_bdd]
  end
  after(:each) do |example|
    Lib::Quizs.user(nil)
    delete_test_data( @datas_bdd[:quizs] ) unless example.metadata[:skip_after_bdd]
  end

  it "Retourne le quiz correspondant à l'id" do
    result = Lib::Quizs.get(@datas_bdd[:quizs][0].id)
    expect(result[:quiz_found][:id]).to eq(@datas_bdd[:quizs][0].id)
    expect(result[:quiz_found][:title]).to eq('Quiz numéro 0')
    expect(result[:quiz_found][:user_id]).to eq('VAA60000')
    expect(result[:quiz_found][:opt_can_redo]).to be_truthy
    expect(result[:quiz_found][:opt_can_rewind]).to be_truthy
    expect(result[:quiz_found][:opt_rand_question_order]).to be_falsey
    expect(result[:quiz_found][:opt_shared]).to be_falsey
    expect(result[:quiz_found][:opt_show_score]).to eq('after_each')
    expect(result[:quiz_found][:opt_show_correct]).to eq('after_each')
  end

  it "Retourne un message d'erreur si le quiz n'est pas trouvé" do
    result = Lib::Quizs.get(-1)
    expect(result[:quiz_found].empty?).to be_truthy
    expect(result[:error][:msg]).to eq("Ce quiz n'existe pas !")
  end

  it 'Crée un nouveau quiz avec les paramètres par défaut', :skip_before_bdd, :skip_after_bdd do
    DB.transaction do
      result = Lib::Quizs.create
      bdd_result = Quizs[id: result[:quiz_created][:id]]
      expect(bdd_result).to_not be_nil
      expect(result[:quiz_created][:title]).to be_nil
      expect(result[:quiz_created][:user_id]).to eq(MOCKED_DATA[:uid])
      expect(result[:quiz_created][:opt_can_redo]).to be_truthy
      expect(result[:quiz_created][:opt_can_rewind]).to be_truthy
      expect(result[:quiz_created][:opt_rand_question_order]).to be_falsey
      expect(result[:quiz_created][:opt_shared]).to be_falsey
      expect(result[:quiz_created][:opt_show_score]).to eq('after_each')
      expect(result[:quiz_created][:opt_show_correct]).to eq('after_each')
      fail Sequel::Rollback
    end
  end

  it "Retourne une erreur raise si l'utilisateur n'a pas été ajouter", :skip_before_user, :skip_before_bdd, :skip_after_bdd do
    result = Lib::Quizs.create
    expect(result[:quiz_created].empty?).to be_truthy
    expect(result[:error][:msg]).to eq('La création du quiz a échoué !')
  end

  it 'Met à jour le quiz' do
    updated_params = {
      id: @datas_bdd[:quizs][0].id,
      title: 'Quiz numéro 0 updated',
      opt_show_score: 'none',
      opt_show_correct: 'none',
      opt_shared: true
    }
    DB.transaction do
      result = Lib::Quizs.update(updated_params)
      bdd_result = Quizs[id: @datas_bdd[:quizs][0].id]
      expect(bdd_result.title).to eq('Quiz numéro 0 updated')
      expect(bdd_result.opt_show_score).to eq('none')
      expect(bdd_result.opt_show_correct).to eq('none')
      expect(bdd_result.opt_rand_question_order).to be_falsey
      expect(bdd_result.opt_shared).to be_truthy

      expect(result[:quiz_updated][:id]).to eq(@datas_bdd[:quizs][0].id)
      expect(result[:quiz_updated][:title]).to eq('Quiz numéro 0 updated')
      expect(result[:quiz_updated][:user_id]).to eq(MOCKED_DATA[:uid])
      expect(result[:quiz_updated][:opt_can_redo]).to be_truthy
      expect(result[:quiz_updated][:opt_can_rewind]).to be_truthy
      expect(result[:quiz_updated][:opt_rand_question_order]).to be_falsey
      expect(result[:quiz_updated][:opt_shared]).to be_truthy
      expect(result[:quiz_updated][:opt_show_score]).to eq('none')
      expect(result[:quiz_updated][:opt_show_correct]).to eq('none')
      fail Sequel::Rollback
    end
  end

  it "Retourne une erreur si l'utilisateur essaye de MAJ un quiz qui ne lui appartient pas " do
    updated_params = {
      id: @datas_bdd[:quizs][1].id,
      title: 'Quiz numéro 1 updated',
      opt_show_score: 'none',
      opt_show_correct: 'none',
      opt_shared: true
    }
    result = Lib::Quizs.update(updated_params)
    bdd_result = Quizs[id: @datas_bdd[:quizs][1].id]
    expect(bdd_result.title).to eq('Quiz numéro 1')
    expect(bdd_result.opt_show_score).to eq('at_end')
    expect(bdd_result.opt_show_correct).to eq('at_end')
    expect(bdd_result.opt_can_redo).to be_falsey
    expect(bdd_result.opt_can_rewind).to be_falsey
    expect(bdd_result.opt_rand_question_order).to be_falsey
    expect(bdd_result.opt_shared).to be_falsey

    expect(result[:quiz_updated].empty?).to be_truthy
    expect(result[:error][:msg]).to eq("Vous n'avez pas l'autorisation de modifier ce quiz !")
  end

  it 'Retourne une erreur raise si le params id est nil', :skip_before_user, :skip_before_bdd, :skip_after_bdd do
    result = Lib::Quizs.update({})
    expect(result[:quiz_updated].empty?).to be_truthy
    expect(result[:error][:msg]).to eq('La mis à jour du quiz a échoué !')
  end

  it 'supprime un quiz' do
    DB.transaction do
      result = Lib::Quizs.delete(@datas_bdd[:quizs][0].id)
      quiz_bdd = Quizs[id: @datas_bdd[:quizs][0].id]
      expect(result[:quiz_deleted][:title]).to eq('Quiz numéro 0')
      expect(result[:quiz_deleted][:user_id]).to eq('VAA60000')
      expect(result[:quiz_deleted][:opt_show_score]).to eq('after_each')
      expect(result[:quiz_deleted][:opt_shared]).to be_falsey
      expect(quiz_bdd).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'duplique un quiz' do
    DB.transaction do
      result = Lib::Quizs.duplicate(@datas_bdd[:quizs][0].id)
      quiz_bdd = Quizs[id: result[:quiz_duplicated][:id]]
      expect(result[:quiz_duplicated][:title]).to eq('Quiz numéro 0')
      expect(result[:quiz_duplicated][:user_id]).to eq('VAA60000')
      expect(result[:quiz_duplicated][:opt_show_score]).to eq('after_each')
      expect(result[:quiz_duplicated][:opt_shared]).to be_falsey
      expect(result[:quiz_duplicated][:id]).to_not eq(@datas_bdd[:quizs][0].id)
      expect(quiz_bdd).to_not be_nil
      fail Sequel::Rollback
    end
  end

  it "Récupère les quizs partagés sauf ceux de l'utilisateur courent" do
    results = Lib::Quizs.shared
    list_quizs_id = [@datas_bdd[:quizs][5..7].map(&:id)]
    expect(results[:quizs_shared].size).to eq(3)
    expect(list_quizs_id.include?(results[:quizs_shared][0][:id]))
    expect(list_quizs_id.include?(results[:quizs_shared][1][:id]))
    expect(list_quizs_id.include?(results[:quizs_shared][2][:id]))
  end
end
