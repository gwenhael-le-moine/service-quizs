# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'SuggestionASSTest' do
  before(:each) do |example|
    @datas_bdd = generate_test_data(quizs: true, questions: true, suggestions: true, solutions: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:suggestions] )
      delete_test_data( @datas_bdd[:questions] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'Créer une nouvelle suggestion ass dans la bdd' do
    params_new_suggestion_ass = {
      question_id: @datas_bdd[:questions][1].id,
      text: 'Ma suggestion numéro 4 de la question',
      position: 'R',
      order: 1
    }
    my_suggestion = SuggestionASS.new(params_new_suggestion_ass)
    DB.transaction do
      id_my_suggestion = my_suggestion.create.id
      bdd_my_suggestion = Suggestions[id: id_my_suggestion]
      expect(bdd_my_suggestion).to_not be_nil
      expect(bdd_my_suggestion.question_id).to eq(@datas_bdd[:questions][1].id)
      expect(bdd_my_suggestion.text).to eq('Ma suggestion numéro 4 de la question')
      expect(bdd_my_suggestion.position).to eq('R')
      expect(bdd_my_suggestion.order).to eq(1)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_suggestion = SuggestionASS.new
    expect { my_suggestion.create }.to raise_error(RuntimeError)
  end

  it 'Récupère une suggestion par son id' do
    found_suggestion = SuggestionASS.new({id: @datas_bdd[:suggestions][3].id})
    found_suggestion = found_suggestion.find
    expect(found_suggestion).to_not be_nil
    expect(found_suggestion.question_id).to eq(@datas_bdd[:questions][1].id)
    expect(found_suggestion.text).to eq('Suggestion numéro 3 de la question')
    expect(found_suggestion.position).to eq('R')
    expect(found_suggestion.order).to eq(0)
  end

  it 'La récupération ne retourne rien avec un id à nil' do
    found_suggestion = SuggestionASS.new
    expect(found_suggestion.find).to be_nil
  end

  it "Retourne toutes les suggestions d'une question" do
    suggestions = SuggestionASS.new({question_id: @datas_bdd[:questions][1].id})
    suggestions = suggestions.find_all
    expect(suggestions.count).to eq(3)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    suggestions = SuggestionASS.new({question_id: 'false_question_id'})
    expect(suggestions.find_all).to be_empty
  end

  it "Met à jour les différentes données d'une suggestion" do
    params_updated_suggestion = {
      id: @datas_bdd[:suggestions][3].id,
      text: 'Suggestion numéro 3 de la question updated',
      order: 1
    }
    updated_suggestion = SuggestionASS.new(params_updated_suggestion)
    DB.transaction do
      updated_suggestion.update
      bdd_my_suggestion_updated = Suggestions[id: @datas_bdd[:suggestions][3].id]
      expect(bdd_my_suggestion_updated).to_not be_nil
      expect(bdd_my_suggestion_updated.question_id).to eq(@datas_bdd[:questions][1].id)
      expect(bdd_my_suggestion_updated.text).to eq('Suggestion numéro 3 de la question updated')
      expect(bdd_my_suggestion_updated.position).to eq('R')
      expect(bdd_my_suggestion_updated.order).to eq(1)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la mise à jour échoue' do
    params_updated_suggestion = {
      id: nil,
      text: 'Suggestion numéro 3 de la question updated'
    }
    updated_suggestion = Suggestion.new(params_updated_suggestion)
    expect { updated_suggestion.update }.to raise_error(RuntimeError)
  end

  it 'Supprime une suggestion par rapport à son id' do
    deleted_suggestion = SuggestionASS.new({id: @datas_bdd[:suggestions][3].id})
    DB.transaction do
      deleted_suggestion.delete
      bdd_my_suggestion_deleted = Suggestions[id: @datas_bdd[:suggestions][3].id]
      expect(bdd_my_suggestion_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_suggestion = SuggestionASS.new
    expect { deleted_suggestion.delete }.to raise_error(RuntimeError)
  end

  it "retourne l'odre des suggestions associées si la suggestion est une solution" do
    suggestion = SuggestionASS.new({id: @datas_bdd[:suggestions][2].id, position: 'L'})
    expect(suggestion.solution?).to eq([@datas_bdd[:suggestions][3].order])
  end

  it 'retourne les id des suggestions associées si la suggestion est une solution' do
    suggestion = SuggestionASS.new({id: @datas_bdd[:suggestions][2].id, position: 'L'})
    expect(suggestion.solution?(true)).to eq([@datas_bdd[:suggestions][3].id])
  end

  it "retourne faux si la suggestion n'est pas une solution ou si l'id est null" do
    suggestion = SuggestionASS.new({id: 'false_suggestion_id'})
    expect(suggestion.solution?).to be_falsey
  end

  it 'retourne les ids des suggestions' do
    suggestion = SuggestionASS.new({question_id: @datas_bdd[:questions][1][:id]})
    suggestions_without_leurres = suggestion.find_all_ids
    expect(suggestions_without_leurres.size).to eq(3)
  end

  it 'retourne les ids des solutions' do
    suggestion = SuggestionASS.new({question_id: @datas_bdd[:questions][1][:id], position: 'L'})
    solutions_suggestion = suggestion.find_all_solutions_ids
    expect(solutions_suggestion.size).to eq(1)
  end

  it 'retourne le nombre max de réponse possible' do
    suggestion = SuggestionASS.new({question_id: @datas_bdd[:questions][1][:id]})
    nb_rep_max = suggestion.nb_responses_max
    expect(nb_rep_max).to eq(2)
  end

  it "duplique les suggestion ass d'une question" do
    DB.transaction do
      params_new_question = {
        quiz_id: @datas_bdd[:quizs][1].id,
        type: 'ASS',
        question: 'ma question dupliquée',
        order: 0,
        opt_rand_suggestion_order: true
      }
      new_question = Question.new(params_new_question)
      id = new_question.create.id
      suggestions = SuggestionASS.new({question_id: @datas_bdd[:questions][1][:id]})
      suggestions.duplicate(id)
      suggestions_duplicated = SuggestionASS.new({question_id: id})
      suggestions_duplicated = suggestions_duplicated.find_all
      expect(suggestions_duplicated.count).to eq(3)
      fail Sequel::Rollback
    end
  end
end
