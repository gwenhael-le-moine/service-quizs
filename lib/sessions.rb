# -*- coding: utf-8 -*-
# Module pour les Sessions
require 'pdfkit'

module Lib
  module Sessions
    public

    module_function

    def self.user(user)
      @user = user
      # @user = {
      #   user: 'erasme',
      #   is_logged: true,
      #   uid: 'VAA60000',
      #   login: 'erasme',
      #   sexe: 'M',
      #   nom: 'Levallois',
      #   prenom: 'Pierre-Gilles',
      #   date_naissance: '1970-02-06',
      #   adresse: '1 rue Sans Nom Propre',
      #   code_postal: '69000',
      #   ville: 'Lyon',
      #   bloque: nil,
      #   id_jointure_aaf: nil,
      #   avatar: '',
      #   roles_max_priority_etab_actif: 3
      # }
    end

    def self.create(quiz_id)
      params_session = {
        quiz_id: quiz_id,
        user_id: @user[:uid],
        user_type: @user[:user_detailed]['profil_actif']['profil_id'],
        score: 0
      }
      session = Session.new(params_session)
      session_created = session.create
      # On retourne le quiz sous forme de hash
      {session_created: session_created.to_hash}
    rescue => err
      LOGGER.error "Impossible de créer la nouvelle session ! message de l'erreur raise: " + err.message
      {session_created: {}, error: {msg: 'La création de la session a échoué !'}}
    end

    def self.get(id)
      session = Session.new(id: id)
      session_found = session.find
      # on Retourne le quiz sous forme de hash
      if session_found.nil?
        LOGGER.error "Impossible de récupérer la session d'id: " + id.to_s + ' !'
        {session_found: {}, error: {msg: "Cette session n'existe pas !"}}
      else
        {session_found: session_found.to_hash}
      end
    end

    def self.get_all(quiz_id = nil)
      sessions = []
      user_type = @user[:user_detailed]['profil_actif']['profil_id']
      case user_type
      when 'ELV'
        sessions = get_all_sessions_elv(@user, quiz_id)
      when 'TUT'
        sessions = get_all_sessions_tut(@user, quiz_id)
      else
        sessions = get_all_sessions_prof(@user, quiz_id)
      end
      {sessions_found: sessions}
    rescue => err
      LOGGER.error "Impossible de récupérer toutes les sessions de l'utilisateur courant ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {sessions_found: [], error: {msg: 'Impossible de récupérer les sessions !'}}
    end

    def self.exist?(quiz_id)
      params_session = {
        quiz_id: quiz_id,
        user_id: @user[:uid],
        user_type: @user[:user_detailed]['profil_actif']['profil_id']
      }
      session = Session.new(params_session)
      session_exist = false
      session_exist = true if session.find_all.count > 0
      {exist: session_exist}
    end

    def self.delete(ids)
      ids.each do |id|
        session = Session.new(id: id)
        quiz = Quiz.new(id: session.find.quiz_id)
        session.delete if @user[:uid] == quiz.find.user_id
      end
      {sessions_deleted: ids}
    rescue => err
      LOGGER.error "Impossible de supprimer les sessions ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {sessions_deleted: [], error: {msg: 'Impossible de supprimer les sessions !'}}
    end

    def self.generate_pdf(sessions)
      final_document = Lib::Pdf::PdfGenerator.generate_sessions(@user, sessions)

      # generate pdf
      kit = PDFKit.new(final_document, page_size: 'Letter')

      kit.stylesheets << 'public/app/styles/pdf.css'
      kit.to_pdf
    end

    private

    module_function

    def get_all_sessions_elv(user, quiz_id = nil)
      fullname = user[:prenom] + ' ' + user[:nom].downcase
      sessions_found = []
      sessions = Session.new(user_id: user[:uid], user_type: 'ELV', quiz_id: quiz_id)
      sessions = sessions.find_all.order(Sequel.desc(:updated_at))
      sessions = sessions.limit(5) if quiz_id.nil?
      sessions.each do |session|
        sessions_found.push(format_get_session(session, fullname, user[:user_detailed]['classes'][0]))
      end
      sessions_found
    end

    def get_all_sessions_tut(user, quiz_id = nil)
      sessions_found = []
      user[:user_detailed]['enfants'].each do |child|
        child_sessions = get_all_sessions_elv({
                                                nom: child['enfant']['nom'],
                                                prenom: child['enfant']['prenom'],
                                                uid: child['enfant']['id_ent'],
                                                user_detailed: {'classes' => child['classes']}
                                              }, quiz_id)
        sessions_found |= child_sessions
      end
      sessions_found
    end

    def get_all_sessions_prof(user, quiz_id = nil)
      sessions_found = []
      if quiz_id
        quiz_ids = [quiz_id]
      else
        quiz_ids = Quiz.new(user_id: user[:uid])
        quiz_ids = quiz_ids.find_all.select(:id).map(:id)
      end
      sessions = Session.new(user_id: user[:uid])
      sessions = sessions.find_all_elv_of_prof(quiz_ids)
      sessions = sessions.limit(5) if quiz_id.nil?
      uids = sessions.select(:user_id).distinct(:user_id).map(:user_id)
      eleves = get_users(uids)
      i = 0
      sessions.each do |session|
        elv = eleves[eleves.index { |s| s['id_ent'] }]
        classe = get_classe_to_user(elv)
        fullname = elv['prenom'] + ' ' + elv['nom'].downcase
        sessions_found.push(format_get_session(session, fullname, classe))
        i += 1
      end
      sessions_found
    end

    def format_get_session(session, fullname, classe)
      quiz = Quiz.new(id: session.quiz_id)
      quiz = quiz.find
      {
        id: session.id,
        quiz: {
          id: session.quiz_id,
          title: quiz.title
        },
        student: {
          uid: session.user_id,
          name: fullname
        },
        classe: {
          id: classe['classe_id'],
          name: classe['classe_libelle'],
          nameEtab: classe['etablissement_nom']
        },
        score: session.score.round,
        date: session.updated_at
      }
    end

    def get_users(uids)
      users = []
      while uids.size > 50
        users.concat(Laclasse::CrossApp::Sender.send_request_signed(:service_annuaire_user, 'liste/' + uids.pop(50).join('_').to_s, 'expand' => 'true'))
      end
      users.concat(Laclasse::CrossApp::Sender.send_request_signed(:service_annuaire_user, 'liste/' + uids.join('_').to_s, 'expand' => 'true')) unless uids.empty?
      users
    end

    def get_classe_to_user(elv)
      classes = elv['regroupements'].select { |s| s['type'] == 'CLS' }
      {
        'classe_id' => classes[0]['id'],
        'classe_libelle' => classes[0]['libelle'],
        'etablissement_nom' => classes[0]['etablissement_nom']
      }
    end
  end
end
