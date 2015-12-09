# -*- coding: utf-8 -*-
# Module pour les Sessions

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
      LOGGER.error "Impossible de créer la nouvelle session ! message de l'erreur raise: "+err.message
      {session_created: {}, error:{msg: "La création de la session a échoué !"}}
    end

    def self.get(id)
      session = Session.new({id: id})
      session_found = session.find
      # on Retourne le quiz sous forme de hash
      if session_found.nil?
        LOGGER.error "Impossible de récupérer la session d'id: "+id.to_s+" !"
        {session_found: {}, error:{msg: "Cette session n'existe pas !"}} 
      else
        {session_found: session_found.to_hash}        
      end
    end

    def self.get_all
      sessions = []
      user_type = @user[:user_detailed]['profil_actif']['profil_id']
      case user_type
      when "ELV"
        sessions = get_all_sessions_elv(@user)
      when "TUT"
        sessions = get_all_sessions_tut(@user)
      else
        sessions = get_all_sessions_prof(@user)       
      end
      {sessions_found: sessions}        
    rescue => err
      LOGGER.error "Impossible de récupérer toutes les sessions de l'utilisateur courant ! message de l'erreur raise: "+err.message + err.backtrace.inspect
      {sessions_found: [], error:{msg: "Impossible de récupérer les sessions !"}}
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

    private

    module_function

    def get_all_sessions_elv(user)
      fullname = user[:prenom] + " " + user[:nom].downcase
      sessions_found = []
      sessions = Session.new({user_id: user[:uid], user_type: 'ELV'})
      sessions = sessions.find_all.order(Sequel.desc(:updated_at)).limit(5)
      sessions.each do |session|
        sessions_found.push(format_get_session(session, fullname))
      end
      sessions_found
    end

    def get_all_sessions_tut(user)
      sessions_found = []
      childs = []
      user[:user_detailed]['enfants'].each do |child|
        child_sessions = get_all_sessions_elv({
          :nom => child['enfant']['nom'],
          :prenom => child['enfant']['prenom'],
          :uid => child['enfant']['id_ent']
        })
        sessions_found = sessions_found | child_sessions
      end
      sessions_found
    end

    def get_all_sessions_prof(user)
      sessions_found = []
      quiz_ids = Quiz.new({user_id: user[:uid]})
      quiz_ids = quiz_ids.find_all.select(:id).map(:id)
      sessions = Session.new({user_id: user[:uid]})
      sessions = sessions.find_all_elv_of_prof(quiz_ids)
      uids = sessions.select(:user_id).distinct(:user_id).map(:user_id)
      users = Laclasse::CrossApp::Sender.send_request_signed(:service_annuaire_user, 'liste/' + uids.join('_').to_s, {}) unless uids.empty?
      sessions.each do |session|
        user = users[users.index { |s| s['id_ent'] }]
        fullname = user['prenom'] + " " + user['nom'].downcase
        sessions_found.push(format_get_session(session, fullname))
      end
      sessions_found
    end

    def format_get_session(session, fullname)
      quiz = Quiz.new({id: session.quiz_id})
      quiz = quiz.find
      {
        id: session.id,
        quiz: {
          id: session.quiz_id,
          title: quiz.title
        },
        student:{
          uid: session.user_id,
          name: fullname
        },
        date: session.updated_at
      }
    end
  end
end