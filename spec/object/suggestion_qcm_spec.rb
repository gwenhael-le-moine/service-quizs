# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'SuggestionQCMTest' do
  before(:each) do |example|
    @datas_bdd = generate_test_data(quizs: true, questions: true, suggestions: true, solutions: true) unless example.metadata[:skip_before]
  end

  after(:each) do |example|
    unless example.metadata[:skip_after]
      delete_test_data( @datas_bdd[:solutions] )
      delete_test_data( @datas_bdd[:suggestions] )
      delete_test_data( @datas_bdd[:questions] )
      delete_test_data( @datas_bdd[:quizs] )
    end
  end

  it 'Créer une nouvelle suggestion qcm dans la bdd' do
    params_new_suggestion_qcm = {
      question_id: @datas_bdd[:questions][0].id,
      text: 'Ma suggestion numéro 3 de la question',
      order: 3
    }
    my_suggestion = SuggestionQCM.new(params_new_suggestion_qcm)
    DB.transaction do
      id_my_suggestion = my_suggestion.create.id
      bdd_my_suggestion = Suggestions[id: id_my_suggestion]
      expect(bdd_my_suggestion).to_not be_nil
      expect(bdd_my_suggestion.question_id).to eq(@datas_bdd[:questions][0].id)
      expect(bdd_my_suggestion.text).to eq('Ma suggestion numéro 3 de la question')
      expect(bdd_my_suggestion.position).to eq('L')
      expect(bdd_my_suggestion.order).to eq(3)
      expect(bdd_my_suggestion.medium_id).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_suggestion = SuggestionQCM.new
    expect { my_suggestion.create }.to raise_error(RuntimeError)
  end

  it 'Récupère une suggestion par son id' do
    found_suggestion = SuggestionQCM.new({id: @datas_bdd[:suggestions][0].id})
    found_suggestion = found_suggestion.find
    expect(found_suggestion).to_not be_nil
    expect(found_suggestion.question_id).to eq(@datas_bdd[:questions][0].id)
    expect(found_suggestion.text).to eq('Suggestion numéro 0 de la question')
    expect(found_suggestion.position).to eq('L')
    expect(found_suggestion.order).to eq(0)
    expect(found_suggestion.medium_id).to be_nil
  end

  it 'La récupération ne retourne rien avec un id à nil' do
    found_suggestion = SuggestionQCM.new
    expect(found_suggestion.find).to be_nil
  end

  it "Retourne toutes les suggestions d'une question" do
    suggestions = SuggestionQCM.new({question_id: @datas_bdd[:questions][0].id})
    suggestions = suggestions.find_all
    expect(suggestions.count).to eq(2)
  end

  it "La récupération ne retourne vide si l'id est faux" do
    suggestions = SuggestionQCM.new({question_id: 'false_question_id'})
    expect(suggestions.find_all).to be_empty
  end

  it "Met à jour les différentes données d'une suggestion" do
    params_updated_suggestion = {
      id: @datas_bdd[:suggestions][0].id,
      text: 'Suggestion numéro 0 de la question updated',
      order: 2
    }
    updated_suggestion = SuggestionQCM.new(params_updated_suggestion)
    DB.transaction do
      updated_suggestion.update
      bdd_my_suggestion_updated = Suggestions[id: @datas_bdd[:suggestions][0].id]
      expect(bdd_my_suggestion_updated).to_not be_nil
      expect(bdd_my_suggestion_updated.question_id).to eq(@datas_bdd[:questions][0].id)
      expect(bdd_my_suggestion_updated.text).to eq('Suggestion numéro 0 de la question updated')
      expect(bdd_my_suggestion_updated.position).to eq('L')
      expect(bdd_my_suggestion_updated.order).to eq(2)
      expect(bdd_my_suggestion_updated.medium_id).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la mise à jour échoue' do
    params_updated_suggestion = {
      id: nil,
      text: 'Suggestion numéro 0 de la question updated'
    }
    updated_suggestion = Suggestion.new(params_updated_suggestion)
    expect { updated_suggestion.update }.to raise_error(RuntimeError)
  end

  it 'Supprime une suggestion par rapport à son id' do
    deleted_suggestion = SuggestionQCM.new({id: @datas_bdd[:suggestions][0].id})
    DB.transaction do
      deleted_suggestion.delete
      bdd_my_suggestion_deleted = Suggestions[id: @datas_bdd[:suggestions][0].id]
      expect(bdd_my_suggestion_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_suggestion = SuggestionQCM.new
    expect { deleted_suggestion.delete }.to raise_error(RuntimeError)
  end

  it 'retourne vrai si la suggestion est une solution' do
    suggestion = SuggestionQCM.new({id: @datas_bdd[:suggestions][0].id})
    expect(suggestion.solution?).to be_truthy
  end

  it "retourne faux si la suggestion n'est pas une solution ou si l'id est null" do
    suggestion = SuggestionQCM.new({id: 'false_suggestion_id'})
    expect(suggestion.solution?).to be_falsey
  end

  it 'retourne les ids des suggestions' do
    suggestion = SuggestionQCM.new({question_id: @datas_bdd[:questions][0][:id]})
    suggestions = suggestion.find_all_ids
    expect(suggestions.size).to eq(2)
  end

  it 'retourne les ids des solutions' do
    suggestion = SuggestionQCM.new({question_id: @datas_bdd[:questions][0][:id]})
    solutions_suggestion = suggestion.find_all_solutions_ids
    expect(solutions_suggestion.size).to eq(1)
  end

  it 'retourne le nombre max de réponse possible' do
    suggestion = SuggestionQCM.new({question_id: @datas_bdd[:questions][0][:id]})
    nb_rep_max = suggestion.nb_responses_max
    expect(nb_rep_max).to eq(2)
  end

  it "duplique les suggestion qcm d'une question" do
    DB.transaction do
      params_new_question = {
        quiz_id: @datas_bdd[:quizs][1].id,
        type: 'QCM',
        question: 'ma question dupliquée',
        order: 0,
        opt_rand_suggestion_order: true
      }
      new_question = Question.new(params_new_question)
      id = new_question.create.id
      suggestions = SuggestionQCM.new({question_id: @datas_bdd[:questions][0][:id]})
      suggestions.duplicate(id)
      suggestions_duplicated = SuggestionQCM.new({question_id: id})
      suggestions_duplicated = suggestions_duplicated.find_all
      expect(suggestions_duplicated.count).to eq(2)
      fail Sequel::Rollback
    end
  end

  it 'retourne la solution a partir de left_suggestion_id' do
    params_founded_solution = {
      left_suggestion_id: @datas_bdd[:suggestions][0].id
    }
    founded_solution = SolutionQCM.new(params_founded_solution)
    founded_solution = founded_solution.find
    expect(founded_solution).to_not be_nil
  end
end
