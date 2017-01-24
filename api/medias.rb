# -*- coding: utf-8 -*-

# Classe Grape de Quizs
class MediasApi < Grape::API
  format :json
  rescue_from :all

  desc 'upload un media'
  params do
    requires :id, type: Integer, desc: 'Id de la question ou de la suggestion'
    requires :type, type: String, desc: 'Type de media, question ou suggestion'
    requires :file
  end
  post '/upload' do
    begin
      new_filename = MEDIA_DIR + params[:file][:filename]
      puts new_filename.inspect
      FileUtils.cp params[:file][:tempfile], new_filename
      
      my_file = File.open(new_filename)
      
      {file: my_file, id: params[:id], type: params[:type]}
    rescue
     error!("Impossible d'uploder le document", 404)
    end
  end
end
