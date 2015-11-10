# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'QuizTest' do
	before(:each) do |example|
    @quizs_bdd = generate_test_data({quizs: true})[:quizs] unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    delete_test_data( @quizs_bdd ) unless example.metadata[:skip_after]
  end

  it "Créer un nouveau quiz dans la bdd", :skip_before, :skip_after do
  	params_new_quiz = {
  		user_id: "VAA60000",
  		title: "Mon Quiz de test",
  		opt_show_score: 'after_each', 
	    opt_show_correct: 'after_each',
	    opt_can_redo: true,
	    opt_can_rewind: true,
	    opt_rand_question_order: false,
	    opt_shared: false
  	}
    my_quiz = Quiz.new(params_new_quiz)
    DB.transaction do
	    id_my_quiz = my_quiz.create.id
	    bdd_my_quiz = Quizs[:id => id_my_quiz]
	    expect(bdd_my_quiz).to_not be_nil
	    expect(bdd_my_quiz.created_at).to_not be_nil
	    expect(bdd_my_quiz.updated_at).to_not be_nil
	    expect(bdd_my_quiz.user_id).to eq("VAA60000")
	    expect(bdd_my_quiz.title).to eq("Mon Quiz de test")
	    expect(bdd_my_quiz.opt_show_score).to eq("after_each")
	    expect(bdd_my_quiz.opt_show_correct).to eq("after_each")
	    expect(bdd_my_quiz.opt_can_redo).to eq(true)
	    expect(bdd_my_quiz.opt_can_rewind).to eq(true)
	    expect(bdd_my_quiz.opt_shared).to eq(false)
	    expect(bdd_my_quiz.opt_rand_question_order).to eq(false)
	    raise Sequel::Rollback
	  end
  end

  it "Retourne une erreur raise si la création échoue", :skip_before, :skip_after do
    my_quiz = Quiz.new
    expect { my_quiz.create }.to raise_error(RuntimeError)
  end

  it "Récupère un quiz par son id" do
  	found_quiz = Quiz.new({id: @quizs_bdd[0].id})
  	found_quiz = found_quiz.find
  	expect(found_quiz).to_not be_nil
    expect(found_quiz.created_at).to_not be_nil
    expect(found_quiz.updated_at).to_not be_nil
    expect(found_quiz.user_id).to eq("VAA60000")
    expect(found_quiz.title).to eq("Quiz numéro 0")
    expect(found_quiz.opt_show_score).to eq("after_each")
    expect(found_quiz.opt_show_correct).to eq("after_each")
    expect(found_quiz.opt_can_redo).to eq(true)
    expect(found_quiz.opt_can_rewind).to eq(true)
    expect(found_quiz.opt_shared).to eq(false)
    expect(found_quiz.opt_rand_question_order).to eq(false)
  end

  it "La récupération ne retourne rien avec un id à nil" do
  	found_quiz = Quiz.new
  	expect(found_quiz.find).to be_nil
  end

  it "Retourne tous les quizs d'un utilisateur" do
  	user_quizs = Quiz.new({user_id: "VAA60000"})
  	user_quizs = user_quizs.find_all
  	expect(user_quizs.count).to eq(2)
  end

  it "Retourne tous les quizs partagés" do
  	shared_quizs = Quiz.new({opt_shared: true})
  	shared_quizs = shared_quizs.find_all
  	expect(shared_quizs.count).to eq(4)
  end

  it "La récupération ne retourne vide si l'id est faux" do
  	user_quizs = Quiz.new({user_id: "false_user_id"})
  	expect(user_quizs.find_all).to be_empty
  end

  it "Met à jour le nom ainsi que les paramètres d'un quiz" do
  	params_updated_quiz = {
  		id: @quizs_bdd[1].id,
  		title: "Quiz numéro 1 updated",
  		opt_show_score: 'none', 
	    opt_show_correct: 'none',
	    opt_can_redo: true,
	    opt_can_rewind: true,
	    opt_rand_question_order: true,
	    opt_shared: true
  	}
  	updated_quiz = Quiz.new(params_updated_quiz)
  	DB.transaction do 
	  	updated_quiz.update
	  	bdd_my_quiz_updated = Quizs[:id => @quizs_bdd[1].id]
	  	expect(bdd_my_quiz_updated).to_not be_nil
	    expect(bdd_my_quiz_updated.created_at).to_not be_nil
	    expect(bdd_my_quiz_updated.updated_at).to_not be_nil
	    expect(bdd_my_quiz_updated.user_id).to eq("VAA60001")
	    expect(bdd_my_quiz_updated.title).to eq("Quiz numéro 1 updated")
	    expect(bdd_my_quiz_updated.opt_show_score).to eq('none')
	    expect(bdd_my_quiz_updated.opt_show_correct).to eq('none')
	    expect(bdd_my_quiz_updated.opt_can_redo).to eq(true)
	    expect(bdd_my_quiz_updated.opt_can_rewind).to eq(true)
	    expect(bdd_my_quiz_updated.opt_shared).to eq(true)
	    expect(bdd_my_quiz_updated.opt_rand_question_order).to eq(true)
	    raise Sequel::Rollback
	  end
  end

  it "Retourne une erreur raise si la mise à jour échoue" do
  	params_updated_quiz = {
  		id: nil,
  		title: "Quiz numéro 1 updated"
  	}
  	updated_quiz = Quiz.new(params_updated_quiz)
  	expect { updated_quiz.update }.to raise_error(RuntimeError)
  end

  it "Supprime un quiz par rapport à son id" do
  	deleted_quiz = Quiz.new({id: @quizs_bdd[0].id})
  	DB.transaction do
  		deleted_quiz.delete
  		bdd_my_quiz_deleted = Quizs[:id => @quizs_bdd[0].id]
  		expect(bdd_my_quiz_deleted).to be_nil
  		raise Sequel::Rollback
	  end
	end
	it "retourne une erreur raise si la suppression échoue" do
  	deleted_quiz = Quiz.new()
		expect { deleted_quiz.delete }.to raise_error(RuntimeError)
	end
end