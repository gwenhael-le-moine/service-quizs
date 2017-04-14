# -*- coding: utf-8 -*-
# Module pour les Quizs

module Lib
  module Quizs
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

    # Fonction qui récupère le quiz correspondant à l'id
    def self.get(id)
      quiz = Quiz.new(id: id)
      quiz_found = quiz.find
      # on Retourne le quiz sous forme de hash
      if quiz_found.nil?
        LOGGER.error "Impossible de récupérer le quiz d'id: " + id.to_s + ' !'
        {quiz_found: {}, error: {msg: "Ce quiz n'existe pas !"}}
      else
        {quiz_found: quiz_found.to_hash}
      end
    end

    # Fonction qui récupère les quizs de l'utilisateur courant
    def self.all
      quizs = []
      user_type = @user[:user_detailed]['profil_actif']['profil_id']
      case user_type
      when 'ELV'
        quizs = get_all_quizs_elv(@user)
      when 'TUT'
        quizs = get_all_quizs_tut(@user)
      else
        quizs = get_all_quizs_prof(@user)
      end

      {quizs_found: quizs}
    rescue => err
      LOGGER.error "Impossible de récupérer tous les quizs de l'utilisateur courant ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {quizs_found: [], error: {msg: 'Impossible de récupérer les quizs !'}}
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
      LOGGER.error "Impossible de créer le nouveau quiz ! message de l'erreur raise: " + err.message
      {quiz_created: {}, error: {msg: 'La création du quiz a échoué !'}}
    end

    # Fonction qui met à jour un quiz
    def self.update(params_modified)
      quiz = Quiz.new(params_modified)
      # on vérifie si le quiz appartient à l'utilisateur courant
      quiz_found = quiz.find
      if quiz_found.user_id == @user[:uid]
        quiz_updated = quiz.update
        # On retourne le quiz sous forme de hash
        {quiz_updated: quiz_updated.to_hash}
      else
        # On retourne une erreur d'autorisation
        LOGGER.error "ATTENTION !! l'utilisateur: '" + @user[:uid] + "' a essayé de mettre à jour le quiz: '" + quiz_found.id.to_s + "' appartenant à un autre utilisateur: '" + quiz_found.user_id + "' !"
        {quiz_updated: {}, error: {msg: "Vous n'avez pas l'autorisation de modifier ce quiz !"}}
      end
    rescue => err
      LOGGER.error "Impossible de mettre à jour le quiz corespondant à l'id: " + params_modified[:id].to_s + " ! message de l'erreur raise: " + err.message
      {quiz_updated: {}, error: {msg: 'La mis à jour du quiz a échoué !'}}
    end

    # Fonction qui supprime le quiz correspondant à l'id
    def self.delete(id)

      publications = Publication.new(quiz_id: id)
          publications.find_all.each do |publication|
              sessions = Sessions.where(publication_id: publication.id)
            sessions.destroy
            publication.delete
          end
      quiz_deleted = {}
      quiz = Quiz.new(id: id)
      quiz = quiz.find
      if quiz.user_id == @user[:uid]
        quiz_deleted = quiz.to_hash
        quiz.delete
      end
      {quiz_deleted: quiz_deleted}
    rescue => err
      LOGGER.error "Impossible de supprimer le quiz ! message de l'erreur raise: " + err.message
      {quiz_deleted: {}, error: {msg: 'La suppréssion du quiz a échoué !'}}
    end

    def self.duplicate(id)
      quiz = Quiz.new(id: id, user_id: @user[:uid])
      quiz = quiz.duplicate
      {quiz_duplicated: quiz}
    rescue => err
      LOGGER.error "Impossible de dupliquer le quiz ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {quiz_duplicated: {}, error: {msg: 'Le clonage du quiz a échoué !'}}
    end

    def self.shared
      quizs_shared = []
      quizs = Quiz.new(opt_shared: true, user_id: @user[:uid])
      quizs = quizs.find_all
      # uids = quizs.select(:user_id).distinct(:user_id).map(:user_id)
      # users = Laclasse::CrossApp::Sender.send_request_signed(:service_annuaire_user, 'liste/' + uids.join('_').to_s, {}) unless uids.empty?
      quizs.each do |quiz|
        # user = users[users.index { |s| s['id_ent'] }]
        questions = Question.new(quiz_id: quiz.id)
        quizs_shared.push(          id: quiz.id,
                                    title: quiz.title,
                                    nbQuestion: questions.find_all.count,
                                    canRedo: quiz.opt_can_redo,
                                    date: quiz.updated_at)
      end
      {quizs_shared: quizs_shared}
    rescue => err
      LOGGER.error "Impossible de récupérer les quizs partagés ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {quizs_shared: {}, error: {msg: 'La récupération des quizs partagés a échoué !'}}
    end

    private

    module_function

    # Récupère les quizs d'un prof
    def get_all_quizs_prof(user)
      quizs_found = []
      quizs = Quiz.new(user_id: user[:uid])
      quizs = quizs.find_all
      quizs.each do |quiz|
        quizs_found.push(format_get_quiz_prof(user, quiz))
      end
      quizs_found
    end

      def format_get_quiz_prof(user, quiz, to_date = nil)
      Lib::Publications.user(user)
      questions = Question.new(quiz_id: quiz.id)
      session = Session.new(quiz_id: quiz.id, user_id: user[:uid], user_type: user[:user_detailed]['profil_actif']['profil_id'])
      session = session.find_all.order(Sequel.desc(:score)).first
      session = session.to_hash unless session.nil?
      if quiz
        formated_quiz = {
          id: quiz.id,
          title: quiz.title,
          nbQuestion: questions.find_all.count,
          canRedo: quiz.opt_can_redo,
          share: quiz.opt_shared,
          session: session,
          publishes: Lib::Publications.get_all(quiz.id)[:publications_found],
          toDate: to_date
        }
      end
      formated_quiz
end

    # Récupère les quizs d'un élève
    def get_all_quizs_elv(user)
      quizs = []
      quizs_found = []
      uai_etab_actif = user[:user_detailed]['profil_actif']['etablissement_code_uai']
      classes = user[:user_detailed]['classes'].uniq { |s| s['classe_id'] }
      classes.each do |classe|
        if classe['etablissement_code'] == uai_etab_actif
          quizs |= get_all_publications(classe['classe_id'])
        end
      end
      # à decommenter si on veut afficher qu'une seule publication
      # quizs = quizs.uniq { |s| s[:id] }
      quizs.each do |q|
        quiz = Quiz.new(id: q[:id])
        quiz = quiz.find
     quizs_found << format_get_quiz(user, quiz, q[:to_date], q[:publication_id])
      end
      quizs_found
    end

    # Récupère les quizs des enfants du tuteur
    def get_all_quizs_tut(user)
      quizs = []
      childs = []
      # On pour chaque enfant on enregistre ses infos et on récupère ses quizs
      user[:user_detailed]['enfants'].each do |child|
        child_infos = {
          uid: child['enfant']['id_ent'],
          user_detailed: {
            'profil_actif' => {
              'etablissement_code_uai' => child['etablissements'][0]['code_uai'],
              'profil_id' => 'ELV'
            },
            'classes' => child['classes']
          }
        }
        child_quizs = get_all_quizs_elv(child_infos)
        childs.push(          uid: child['enfant']['id_ent'],
                              name: child['enfant']['prenom'] + ' ' + child['enfant']['nom'].downcase,
                              quizs: child_quizs.collect { |s| s[:id] })
        quizs |= child_quizs
      end
      {quizs: quizs, childs: childs}
    end



    # Insère les informations dans le bon format
    def format_get_quiz(user, quiz, to_date = nil, publication_id)
      Lib::Publications.user(user)
      questions = Question.new(quiz_id: quiz.id)
      session = Session.new(publication_id: publication_id, user_id: user[:uid], user_type: user[:user_detailed]['profil_actif']['profil_id'])
      session = session.find_all.order(Sequel.desc(:score)).first
      if session
      score = session.score.round
      puts("score")
      p score
    end
      session = session.to_hash unless session.nil?
      if quiz
        formated_quiz = {
          id: quiz.id,
          publication_id: publication_id,
          title: quiz.title,
          nbQuestion: questions.find_all.count,
          canRedo: quiz.opt_can_redo,
          share: quiz.opt_shared,
          session: session,
          publishes: Lib::Publications.get_all(quiz.id)[:publications_found],
          toDate: to_date,
          score: score
        }
      end
      formated_quiz
    end

    # Récupère les publications d'un regroupement en vérifiant les dates
    def get_all_publications(rgpt_id)
      quizs_ids = []
      publications = Publication.new(rgpt_id: rgpt_id)
      publications.find_all.each do |publication|
        # on compare avec la date du jour
        today_date = Time.now.strftime('%Y-%m-%d %H:%M')  
        # date de début du quiz
        publication.from_date.nil? ? from_date_compare = today_date : from_date_compare = publication.from_date.strftime('%Y-%m-%d %H:%M')
        # date de fin du quiz
        if publication.to_date.nil?
          to_date_compare = today_date
          to_date_js = nil
        else
          to_date_compare = to_date_js = publication.to_date.strftime('%Y-%m-%d %H:%M')
        end
        if from_date_compare <= today_date && to_date_compare >= today_date
          publication.nil?
          quizs_ids.push(id: publication.quiz_id, to_date: to_date_js, publication_id:publication.id)
        end
      end
      quizs_ids
    end
  end
end
