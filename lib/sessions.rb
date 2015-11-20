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
  end
end