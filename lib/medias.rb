# -*- coding: utf-8 -*-
# Module pour les médias

module Lib
  module Medias
    public

    module_function

    def self.create(medium)
      params_medium = {
        name: medium[:fullname],
        content_type: medium[:type],
        uri: medium[:file][:url]
      }
      new_medium = Medium.new(params_medium)
      new_medium.create.id
    end

    def self.get(id)
      medium_bdd = Medium.new(id: id)
      medium_bdd = medium_bdd.find
      return {file: nil, type: nil} if medium_bdd.nil?
      medium = {
        id: medium_bdd.id,
        file: {
          name: medium_bdd.name,
          url: nil
        },
        type: medium_bdd.content_type
      }
      if medium_bdd.content_type == 'video'
        medium[:fullname] = medium_bdd.name
        medium[:file][:url] = medium_bdd.uri
        # else #TODO pour les medias dans document
      end
      medium
    end

    def self.update_question(question_id, medium)
      puts '======> update media of the question'
      question = Question.new(id: question_id)
      question = question.find
      puts '======> id medias : ' + medium[:id].inspect
      unless medium[:id]
        delete(question.medium_id)
        medium_id = create(medium)
        puts '=======> new id of medias : ' + medium_id.inspect
      end
      medium_id
    end

    def self.delete(id)
      medium = Medium.new(id: id)
      medium.delete unless id.nil?
    end
  end
end
