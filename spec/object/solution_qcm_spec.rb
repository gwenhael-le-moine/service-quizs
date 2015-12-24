# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'SolutionQCMTest' do
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

  it 'Créer une nouvelle solution qcm dans la bdd' do
    params_new_solution = {
      left_suggestion_id: @datas_bdd[:suggestions][1].id
    }
    my_solution = SolutionQCM.new(params_new_solution)
    DB.transaction do
      id_my_solution = my_solution.create.id
      bdd_my_solution = Solutions[id: id_my_solution]
      expect(bdd_my_solution).to_not be_nil
      expect(bdd_my_solution.left_suggestion_id).to eq(@datas_bdd[:suggestions][1].id)
      expect(bdd_my_solution.right_suggestion_id).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'Retourne une erreur raise si la création échoue', :skip_before, :skip_after do
    my_solution = SolutionQCM.new
    expect { my_solution.create }.to raise_error(RuntimeError)
  end

  it 'Supprime une solution par rapport à son id' do
    deleted_solution = SolutionQCM.new(left_suggestion_id: @datas_bdd[:solutions][0].left_suggestion_id)
    DB.transaction do
      deleted_solution.delete
      bdd_my_solution_deleted = Solutions[id: @datas_bdd[:solutions][0].id]
      expect(bdd_my_solution_deleted).to be_nil
      fail Sequel::Rollback
    end
  end

  it 'retourne une erreur raise si la suppression échoue' do
    deleted_solution = SolutionQCM.new
    expect { deleted_solution.delete }.to raise_error(RuntimeError)
  end
end
