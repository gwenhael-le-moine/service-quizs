# coding: utf-8
require 'htmlentities'

# génération des sessions en pdf
module Lib
  module Pdf
    module PdfGenerator
      def self.generate_sessions(user, sessions)
        final_doc = ''
        quiz_title = sessions[0][:quiz][:title] unless sessions.nil? || sessions.empty?
        couverture = Lib::Pdf::HtmlGenerator.generate_cover(user, "Résultat des sessions du Quiz \"#{quiz_title}\"")
        final_doc = couverture.to_html
        sessions.each do |session|
          document = Lib::Pdf::HtmlGenerator.generate_session(session)
          final_doc = final_doc + document.to_html + '<br></br>'
        end
        final_doc
      end
    end
  end
end
