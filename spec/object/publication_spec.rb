# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'PublicationTest' do
  before(:each) do |example|
    @datas_bdd = generate_test_data(quizs: true, publications: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:publications] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'Créer une nouvelle publication dans la bdd' do
    params_new_publication = {
      quiz_id: @datas_bdd[:quizs][1].id,
      rgpt_id: 1,
      opt_show_score: @datas_bdd[:quizs][1].opt_show_score,
      opt_show_correct: @datas_bdd[:quizs][1].opt_show_correct,
      opt_can_redo: @datas_bdd[:quizs][1].opt_can_redo,
      opt_can_rewind: @datas_bdd[:quizs][1].opt_can_rewind,
      opt_rand_question_order: @datas_bdd[:quizs][1].opt_rand_question_order
    }
    my_publication = Publication.new(params_new_publication)
    DB.transaction do
      id_my_publication = my_publication.create.id
      bdd_my_publication = Publications[id: id_my_publication]
      expect(bdd_my_publication).to_not be_nil
      expect(bdd_my_publication.from_date).to be_nil
      expect(bdd_my_publication.to_date).to be_nil
      expect(bdd_my_publication.quiz_id).to eq(@datas_bdd[:quizs][1].id )
      expect(bdd_my_publication.rgpt_id).to eq(1)
      expect(bdd_my_publication.opt_show_score).to eq('at_end')
      expect(bdd_my_publication.opt_show_correct).to eq('at_end')
      expect(bdd_my_publication.opt_can_redo).to eq(false)
      expect(bdd_my_publication.opt_can_rewind).to eq(false)
      expect(bdd_my_publication.opt_rand_question_order).to eq(false)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_publication = Publication.new
    expect { my_publication.create }.to raise_error(RuntimeError)
  end

  it 'Récupère une publication par son id' do
    found_publication = Publication.new(id: @datas_bdd[:publications][0].id)
    found_publication = found_publication.find
    expect(found_publication).to_not be_nil
    expect(found_publication.from_date).to_not be_nil
    expect(found_publication.to_date).to_not be_nil
    expect(found_publication.quiz_id).to eq(@datas_bdd[:quizs][0].id)
    expect(found_publication.rgpt_id).to eq(1)
    expect(found_publication.opt_show_score).to eq('after_each')
    expect(found_publication.opt_show_correct).to eq('after_each')
    expect(found_publication.opt_can_redo).to eq(true)
    expect(found_publication.opt_can_rewind).to eq(true)
    expect(found_publication.opt_rand_question_order).to eq(false)
  end

  it 'La récupération ne retourne rien avec un id à nil' do
    found_publication = Publication.new
    expect(found_publication.find).to be_nil
  end

  it "Retourne toutes les publications d'un quiz" do
    publications_quiz = Publication.new(quiz_id: @datas_bdd[:quizs][0].id)
    publications_quiz = publications_quiz.find_all
    expect(publications_quiz.count).to eq(1)
  end

  it "Retourne toutes les publications d'un regroupement" do
    publication_rgpt = Publication.new(rgpt_id: 1)
    publication_rgpt = publication_rgpt.find_all
    expect(publication_rgpt.count).to eq(1)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    publications_quiz = Publication.new(quiz_id: 'false_user_id')
    expect(publications_quiz.find_all).to be_empty
  end

  it "Met à jour le from_date ainsi que les paramètres d'une publication" do
    params_updated_publication = {
      id: @datas_bdd[:publications][0].id,
      from_date: Time.new(1985, 10, 26).to_s(:db),
      to_date: Time.new(2015, 10, 21).to_s(:db),
      opt_show_score: 'none',
      opt_show_correct: 'none',
      opt_can_redo: true,
      opt_can_rewind: true,
      opt_rand_question_order: true
    }
    updated_publication = Publication.new(params_updated_publication)
    DB.transaction do
      updated_publication.update
      bdd_my_publication_updated = Publications[id: @datas_bdd[:publications][0].id]
      expect(bdd_my_publication_updated).to_not be_nil
      expect(bdd_my_publication_updated.from_date.to_s(:db)).to eq('1985-10-26 00:00:00')
      expect(bdd_my_publication_updated.to_date.to_s(:db)).to eq('2015-10-21 00:00:00')
      expect(bdd_my_publication_updated.quiz_id).to eq(@datas_bdd[:quizs][0].id)
      expect(bdd_my_publication_updated.rgpt_id).to eq(1)
      expect(bdd_my_publication_updated.opt_show_score).to eq('none')
      expect(bdd_my_publication_updated.opt_show_correct).to eq('none')
      expect(bdd_my_publication_updated.opt_can_redo).to eq(true)
      expect(bdd_my_publication_updated.opt_can_rewind).to eq(true)
      expect(bdd_my_publication_updated.opt_rand_question_order).to eq(true)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la mise à jour échoue' do
    params_updated_publication = {
      id: nil,
      from_date: Time.new(1985, 10, 26).to_s(:db)
    }
    updated_publication = Publication.new(params_updated_publication)
    expect { updated_publication.update }.to raise_error(RuntimeError)
  end

  it 'Supprime une publication par rapport à son id' do
    deleted_publication = Publication.new(id: @datas_bdd[:publications][0].id)
    DB.transaction do
      deleted_publication.delete
      bdd_my_publication_deleted = Publications[id: @datas_bdd[:publications][0].id]
      expect(bdd_my_publication_deleted).to be_nil
      fail Sequel::Rollback
    end
  end
  it 'retourne une erreur raise si la suppression échoue' do
    deleted_publication = Publication.new
    expect { deleted_publication.delete }.to raise_error(RuntimeError)
  end

  it 'Vérifie si une publication est déjà publiée' do
    publication = Publication.new(quiz_id: @datas_bdd[:quizs][0].id, rgpt_id: 1)
    expect(publication.exist?).to be_truthy
  end
end
