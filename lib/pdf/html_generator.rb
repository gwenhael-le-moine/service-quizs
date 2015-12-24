# coding: utf-8
require 'htmlentities'
require 'date'

# Helpers pour les messages HTML
module Lib
  module Pdf
    module HtmlGenerator
      def self.generate_cover(user, titre)
        info =
        "<div>
          <div>
            <span class=\"texte-gras\">#{user[:prenom].capitalize} #{user[:nom].capitalize}</span>
          </div>
          <div>
            <span class=\"texte-secondaire\">#{user[:user_detailed]['profil_actif']['profil_nom'].capitalize} à #{user[:user_detailed]['profil_actif']['etablissement_nom'].upcase}</span>
          </div>
        </div>"
        titre = "<div class=\"grand-titre\"><span>#{titre}</span></div>"

        page = info + titre
        html = HTMLEntities.new.decode page
        document = Nokogiri::HTML(html)
        document
      end

      def self.generate_session(session)
        date_html = "<div class=\"date\">#{DateTime.iso8601(session[:date]).strftime('%d.%m.%y - %kh%M')}</div>
        <div class=\"border\"></div>"
        session_html =
        "<div class=\"session\">
          <div class=\"info-elv\">
            <div><span class=\"texte-gras\">Session de #{session[:student][:name]}</span></div>
            <div><span class=\"texte-secondaire\">élève de #{session[:classe][:name]} à #{session[:classe][:nameEtab]}</span></div>
          </div>
          <div class=\"score\"><span>Score : #{session[:score]} %</span></div>
        </div>"
        page = date_html + session_html
        html = HTMLEntities.new.decode page
        document = Nokogiri::HTML(html)
        document
      end
    end
  end
end
