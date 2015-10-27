# -*- coding: utf-8 -*-
# Module pour les Quizs

module Lib
  module Quizs
    public

    module_function

    def self.user(user)
      # @user = user
      @user = {
        user: 'erasme',
        is_logged: true,
        uid: 'VAA60000',
        login: 'erasme',
        sexe: 'M',
        nom: 'Levallois',
        prenom: 'Pierre-Gilles',
        date_naissance: '1970-02-06',
        adresse: '1 rue Sans Nom Propre',
        code_postal: '69000',
        ville: 'Lyon',
        bloque: nil,
        id_jointure_aaf: nil,
        avatar: '',
        roles_max_priority_etab_actif: 3
      }
    end

    # Fonction qui récupère le quiz correspondant à l'id
    def self.get(id)
      quiz = Quiz.new({id: id})
      quiz_found = quiz.find
      # on Retourne le quiz sous forme de hash
      if quiz_found.nil?
        LOGGER.error "Impossible de récupérer le quiz d'id: "+id.to_s+" !"
        {quiz_found: {}, error:{msg: "Ce quiz n'existe pas !"}} 
      else
        {quiz_found: quiz_found.to_hash}        
      end
    end

    # Fonction qui créé un quiz
    def self.create
      # On créé un quiz par défaut
      default_params = {
        user_id: @user[:uid],
        opt_can_redo: true,
        opt_can_rewind: true,
        opt_rand_question_order: false,
        opt_shared: false,
        opt_show_score: 'after_each',
        opt_show_correct: 'after_each'
      }
      new_default_quiz = Quiz.new(default_params)
      quiz_created = new_default_quiz.create
      # On retourne le quiz sous forme de hash
      {quiz_created: quiz_created.to_hash}
    rescue => err
      LOGGER.error "Impossible de créer le nouveau quiz ! message de l'erreur raise: "+err.message
      {quiz_created: {}, error:{msg: "La création du quiz a échoué !"}}
    end

    # Fonction qui met à jour un quiz
    def self.update(params_modified)      
      quiz = Quiz.new(params_modified)
      #on vérifie si le quiz appartient à l'utilisateur courant
      quiz_found = quiz.find
      if quiz_found.user_id == @user[:uid]
        quiz_updated = quiz.update
        # On retourne le quiz sous forme de hash
        {quiz_updated: quiz_updated.to_hash}              
      else
        # On retourne une erreur d'autorisation
        LOGGER.error "ATTENTION !! l'utilisateur: '"+@user[:uid]+"' a essayé de mettre à jour le quiz: '"+quiz_found.id.to_s+"' appartenant à un autre utilisateur: '"+quiz_found.user_id+"' !"
        {quiz_updated: {}, error:{msg: "Vous n'avez pas l'autorisation de modifier ce quiz !"}}
      end
    rescue => err
      LOGGER.error "Impossible de mettre à jour le quiz corespondant à l'id: "+params_modified[:id].to_s+" ! message de l'erreur raise: "+err.message
      {quiz_updated: {}, error:{msg: "La mis à jour du quiz a échoué !"}}
    end
  end
end