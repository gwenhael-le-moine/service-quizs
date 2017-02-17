module Lib
  module Publications
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

    def self.get_all(quiz_id)
      publications_found = []
      publications = Publication.new(quiz_id: quiz_id)
      publications.find_all.each do |publication|
        publications_found.push(format_get_publication(publication))
      end
      {publications_found: publications_found}
    end

    def self.add(params)
      quiz = Quiz.new(id: params[:quiz_id])
      quiz = quiz.find
      params[:added].each do |regroupement|
        params_publication = {
          quiz_id: quiz.id,
          rgpt_id: regroupement[:id],
          opt_show_score: quiz.opt_show_score,
          opt_show_correct: quiz.opt_show_correct,
          opt_can_redo: quiz.opt_can_redo,
          opt_can_rewind: quiz.opt_can_rewind,
          opt_rand_question_order: quiz.opt_rand_question_order,
          from_date: params[:fromDate],
          to_date: params[:toDate]
      
        }
        p params
          puts("fromDate")
          puts(params[:fromDate])
          puts("toDate")
          puts(params[:toDate].iso8601)
        publication = Publication.new(params_publication)
        publication.create unless publication.exist?
      end
      {}
    rescue => err
      LOGGER.error "Impossible d'ajouter les publications ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {error: {msg: "Impossible d'ajouter les publication !"}}
    end

    def self.delete(publications)
      publications.each do |p|
        publication = Publication.new(id: p[:id])
        publication.delete
      end
      {}
    rescue => err
      LOGGER.error "Impossible de supprimer les publications ! message de l'erreur raise: " + err.message + err.backtrace.inspect
      {error: {msg: 'Impossible de supprimer les publication !'}}
    end

    private

    module_function

    def format_get_publication(publication)
      result = classe?(publication.rgpt_id)
      result = groupe?(publication.rgpt_id) if result[:name_rgpt].empty?
      {
        id: publication.id,
        quiz_id: publication.quiz_id,
        fromDate: publication.from_date,
        toDate: publication.to_date,
        rgptId: publication.rgpt_id,
        name: result[:name_rgpt],
        nameEtab: result[:name_etab]
      }
    end

    def classe?(rgpt_id)
      name_rgpt = ''
      name_etab = ''
      i = 0
      classes = @user[:user_detailed]['classes'].uniq { |s| s['classe_id'] }
      while name_rgpt.empty? && i < classes.size
        if rgpt_id == classes[i]['classe_id']
          name_rgpt = classes[i]['classe_libelle']
          name_etab = classes[i]['etablissement_nom']
        end
        i += 1
      end
      {name_rgpt: name_rgpt, name_etab: name_etab}
    end

    def groupe?(rgpt_id)
      name_rgpt = ''
      name_etab = ''
      i = 0
      groupes = @user[:user_detailed]['groupes_eleves'].uniq { |s| s['groupe_id'] }
      while name_rgpt.empty? && i < groupes.size
        if rgpt_id == groupes[i]['groupe_id']
          name_rgpt = groupes[i]['groupe_libelle']
          name_etab = groupes[i]['etablissement_nom']
        end
        i += 1
      end
      {name_rgpt: name_rgpt, name_etab: name_etab}
    end
  end
end
