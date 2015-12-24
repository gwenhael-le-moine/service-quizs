# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'SolutionASSTest' do
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

  it 'Créer une nouvelle solution ass dans la bdd' do
    params_new_solution = {
      left_suggestion_id: @datas_bdd[:suggestions][4].id,
      right_suggestion_id: @datas_bdd[:suggestions][3].id
    }
    my_solution = SolutionASS.new(params_new_solution)
    DB.transaction do
      id_my_solution = my_solution.create.id
      bdd_my_solution = Solutions[id: id_my_solution]
      expect(bdd_my_solution).to_not be_nil
      expect(bdd_my_solution.left_suggestion_id).to eq(@datas_bdd[:suggestions][4].id)
      expect(bdd_my_solution.right_suggestion_id).to eq(@datas_bdd[:suggestions][3].id)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_solution = SolutionASS.new
    expect { my_solution.create }.to raise_error(RuntimeError)
  end

  it 'Met à jour la solution' do
    params_updated_solution = {
      id: @datas_bdd[:solutions][1].id,
      left_suggestion_id: @datas_bdd[:suggestions][4].id
    }
    updated_solution = SolutionASS.new(params_updated_solution)
    DB.transaction do
      updated_solution.update
      bdd_my_solution_updated = Solutions[id: @datas_bdd[:solutions][1].id]
      expect(bdd_my_solution_updated).to_not be_nil
      expect(bdd_my_solution_updated.left_suggestion_id).to eq(@datas_bdd[:suggestions][4].id)
      expect(bdd_my_solution_updated.right_suggestion_id).to eq(@datas_bdd[:suggestions][3].id)
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la mise à jour échoue' do
    params_updated_solution = {
      id: nil,
      left_suggestion_id: @datas_bdd[:suggestions][4].id
    }
    updated_solution = SolutionASS.new(params_updated_solution)
    expect { updated_solution.update }.to raise_error(RuntimeError)
  end

  it 'Supprime une solution par rapport à son id' do
    deleted_solution = SolutionASS.new(id: @datas_bdd[:solutions][1].id)
    DB.transaction do
      deleted_solution.delete
      bdd_my_solution_deleted = Solutions[id: @datas_bdd[:solutions][1].id]
      expect(bdd_my_solution_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_solution = SolutionASS.new
    expect { deleted_solution.delete }.to raise_error(RuntimeError)
  end

  it 'retourne la solution a partir de left_suggestion_id et right_suggestion_id' do
    params_founded_solution = {
      left_suggestion_id: @datas_bdd[:suggestions][2].id,
      right_suggestion_id: @datas_bdd[:suggestions][3].id
    }
    founded_solution = SolutionASS.new(params_founded_solution)
    founded_solution = founded_solution.find
    expect(founded_solution).to_not be_nil
  end
end
