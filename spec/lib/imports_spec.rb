# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'LibImportsTest' do

  it "Importe une liste de quiz" do
    DB.transaction do
      result = Lib::Imports.set(JSON_IMPORTS_QUIZS)
      expect(result[:quizs].empty?).to be_falsey
      expect(result[:error]).to be_nil
      quizs_bdd = Quizs[:id => result[:quizs][0][:id]]
      nb_question_in_bdd = Questions.where(:quiz_id => result[:quizs][0][:id]).count
      expect(quizs_bdd).to_not be_nil
      expect(nb_question_in_bdd).to eq(3)
      fail Sequel::Rollback
    end  
  end
end