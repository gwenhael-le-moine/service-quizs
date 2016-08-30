# -*- coding: utf-8 -*-
# Module pour les médias

module Lib
  module Medias
    public

    module_function

    def self.create(medium, foreign_key, type)
      params_medium = {
        name: medium[:fullname],
        content_type: medium[:type],
        uri: medium[:file][:url]
      }
      type == 'question' ? params_medium[:questions_id] = foreign_key : params_medium[:suggestions_id] = foreign_key
      new_medium = Medium.new(params_medium)
      new_medium.create.id
    end

    def self.get(foreign_key, type)
      params = {}
      type == 'question' ? params[:questions_id] = foreign_key : params[:suggestions_id] = foreign_key
      medium_bdd = Medium.new(params)
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

    def self.update(medium, foreign_key, type)
      params = {}
      type == 'question' ? params[:questions_id] = foreign_key : params[:suggestions_id] = foreign_key
      medium_bdd = Medium.new(params)
      medium_bdd = medium_bdd.find
      unless medium[:id]
        delete(medium_bdd.id) unless medium_bdd.nil?
        medium[:id] = create(medium, foreign_key, type)
      end
      # cela veut dire que l'on doit supprimer le medium
      if medium[:file].nil? && medium[:id]
        delete(medium_bdd.id) unless medium_bdd.nil?
        medium = {file: nil, type: nil}
      end
      medium
    end

    def self.delete(id)
      medium = Medium.new(id: id)
      medium.delete unless id.nil?
    end
  end
end
