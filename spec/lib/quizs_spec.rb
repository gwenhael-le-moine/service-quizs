# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibQuizsTest' do
	before(:each) do |example|
    Lib::Quizs.user( MOCKED_DATA ) unless example.metadata[:skip_before_user]
    @quizs_bdd = generate_test_data({quizs: true})[:quizs] unless example.metadata[:skip_before_bdd]
  end
  after(:each) do |example|
  	Lib::Quizs.user(nil)
    delete_test_data( @quizs_bdd ) unless example.metadata[:skip_after_bdd]
  end

  it "Retourne le quiz correspondant à l'id" do
  	result = Lib::Quizs.get(@quizs_bdd[0].id)
  	expect(result[:quiz_found][:id]).to eq(@quizs_bdd[0].id)
  	expect(result[:quiz_found][:title]).to eq("Quiz numéro 0")
    expect(result[:quiz_found][:user_id]).to eq("VAA60000")
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

  it "Crée un nouveau quiz avec les paramètres par défaut", :skip_before_bdd, :skip_after_bdd do
  	DB.transaction do
	  	result = Lib::Quizs.create
	  	bdd_result = Quizs[:id => result[:quiz_created][:id]]
	    expect(bdd_result).to_not be_nil
	    expect(result[:quiz_created][:title]).to be_nil
	    expect(result[:quiz_created][:user_id]).to eq(MOCKED_DATA[:uid])
	    expect(result[:quiz_created][:opt_can_redo]).to be_truthy
	    expect(result[:quiz_created][:opt_can_rewind]).to be_truthy
	    expect(result[:quiz_created][:opt_rand_question_order]).to be_falsey
	    expect(result[:quiz_created][:opt_shared]).to be_falsey
	    expect(result[:quiz_created][:opt_show_score]).to eq('after_each')
	    expect(result[:quiz_created][:opt_show_correct]).to eq('after_each')
		  raise Sequel::Rollback
		end
	end

	it "Retourne une erreur raise si l'utilisateur n'a pas été ajouter", :skip_before_user, :skip_before_bdd, :skip_after_bdd do
		result = Lib::Quizs.create
		expect(result[:quiz_created].empty?).to be_truthy
		expect(result[:error][:msg]).to eq("La création du quiz a échoué !")
	end

	it "Met à jour le quiz" do
		updated_params={
			id: @quizs_bdd[0].id,
			title: "Quiz numéro 0 updated",
  		opt_show_score: 'none', 
	    opt_show_correct: 'none',
	    opt_shared: true
		}
		DB.transaction do
			result = Lib::Quizs.update(updated_params)
			bdd_result = Quizs[:id => @quizs_bdd[0].id]
			expect(bdd_result.title).to eq("Quiz numéro 0 updated")
			expect(bdd_result.opt_show_score).to eq('none')
			expect(bdd_result.opt_show_correct).to eq('none')
			expect(bdd_result.opt_rand_question_order).to be_falsey
			expect(bdd_result.opt_shared).to be_truthy

			expect(result[:quiz_updated][:id]).to eq(@quizs_bdd[0].id)
			expect(result[:quiz_updated][:title]).to eq("Quiz numéro 0 updated")
	    expect(result[:quiz_updated][:user_id]).to eq(MOCKED_DATA[:uid])
	    expect(result[:quiz_updated][:opt_can_redo]).to be_truthy
	    expect(result[:quiz_updated][:opt_can_rewind]).to be_truthy
	    expect(result[:quiz_updated][:opt_rand_question_order]).to be_falsey
	    expect(result[:quiz_updated][:opt_shared]).to be_truthy
	    expect(result[:quiz_updated][:opt_show_score]).to eq('none')
	    expect(result[:quiz_updated][:opt_show_correct]).to eq('none')
			raise Sequel::Rollback
		end
	end

	it "Retourne une erreur si l'utilisateur essaye de MAJ un quiz qui ne lui appartient pas " do
		updated_params={
			id: @quizs_bdd[1].id,
			title: "Quiz numéro 1 updated",
  		opt_show_score: 'none', 
	    opt_show_correct: 'none',
	    opt_shared: true
		}
		result = Lib::Quizs.update(updated_params)
		bdd_result = Quizs[:id => @quizs_bdd[1].id]
		expect(bdd_result.title).to eq("Quiz numéro 1")
		expect(bdd_result.opt_show_score).to eq('at_end')
		expect(bdd_result.opt_show_correct).to eq('at_end')
		expect(bdd_result.opt_can_redo).to be_falsey
		expect(bdd_result.opt_can_rewind).to be_falsey
		expect(bdd_result.opt_rand_question_order).to be_falsey
		expect(bdd_result.opt_shared).to be_falsey

		expect(result[:quiz_updated].empty?).to be_truthy
		expect(result[:error][:msg]).to eq("Vous n'avez pas l'autorisation de modifier ce quiz !")
  end

  it "Retourne une erreur raise si le params id est nil", :skip_before_user, :skip_before_bdd, :skip_after_bdd do
		result = Lib::Quizs.update({})
		expect(result[:quiz_updated].empty?).to be_truthy
		expect(result[:error][:msg]).to eq("La mis à jour du quiz a échoué !")
	end
end