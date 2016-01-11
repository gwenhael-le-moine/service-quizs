# -*- coding: utf-8 -*-

module Lib
  module Imports
    public

    module_function

   	def self.set(datas)
   		set_quizs(datas[:quizs]) unless datas[:quizs].nil?
   		set_questions(datas[:questions]) unless datas[:questions].nil?
   		set_suggestions(datas[:suggestions]) unless datas[:suggestions].nil?
   		set_solutions(datas[:solutions]) unless datas[:solutions].nil? 
   	end

   	private

   	module_function

   	def set_quizs(quizs)
   	end

   	def set_questions(questions)
   	end

   	def set_suggestions(suggestions)
   	end

   	def set_solutions(solutions)
   	end
  end
end