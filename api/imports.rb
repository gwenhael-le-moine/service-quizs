# -*- coding: utf-8 -*-

# Classe Grape de réponse
class ImportsApi < Grape::API
  format :json
  rescue_from :all

  desc 'Importe les données en BDD'
  params do
    requires :datas, type: Object, desc: 'Données à importer dans la BDD'
  end
  post '/' do
    Lib::Imports.set(params[:datas])
  end
end