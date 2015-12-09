# -*- coding: utf-8 -*-
# Module pour les Sessions

module Lib
  module Users
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

    def self.get_regroupements(quiz_id)
      regroupements = []
      # on récupère les ids des regroupements dans lequel ce quiz a été publié
      regroupements_published_ids = Publication.new({quiz_id: quiz_id})
      regroupements_published_ids = regroupements_published_ids.find_all.select(:rgpt_id).map(:rgpt_id)
      regroupements = regroupements | get_classes(regroupements_published_ids)
      regroupements = regroupements | get_groupes(regroupements_published_ids)

      {regroupements_found: regroupements}
    rescue => err
      LOGGER.error "Impossible de récupérer les regroupements ! message de l'erreur raise: "+err.message
      {regroupements_found: {}, error:{msg: "La création de la session a échoué !"}}
    end

    private

    module_function

    def get_classes(regroupements_published_ids)
      classes_formated = []
      # on récupère les classes de l'utilisateur au format pour le client
      classes = @user[:user_detailed]['classes'].uniq { |s| s['classe_id'] }
      classes.each do |classe|
        classes_formated.push({
          id: classe['classe_id'],
          type: 'cls',
          name: classe['classe_libelle'],
          nameEtab: classe['etablissement_nom'],
          selected: regroupements_published_ids.include?(classe['classe_id'])
        })
      end
      classes_formated
    end

    def get_groupes(regroupements_published_ids)
      groupes_formated = []
      # on récupère les groupes de l'utilisateur au format pour le client
      groupes = @user[:user_detailed]['groupes_eleves'].uniq { |s| s['groupe_id'] }
      groupes.each do |groupe|
        groupes_formated.push({
          id: groupe['groupe_id'],
          type: 'grp',
          name: groupe['groupe_libelle'],
          nameEtab: groupe['etablissement_nom'],
          selected: regroupements_published_ids.include?(groupe['groupe_id'])
        })
      end
      groupes_formated
    end
  end
end