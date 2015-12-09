# -*- coding: utf-8 -*-
# Module pour les réponses

module Lib
  module Answers
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

    def self.create(params)
      # si l'utilisateur à déjà répondu à cette question,
      # on doit supprimer ses anciennes réponses
      delete_old_answers(params)
      answers = []
      case params[:question][:type]
      when "qcm"
        answers = create_answers_qcm(params)
        suggestions = SuggestionQCM.new({question_id: params[:question][:id]})
      when "ass"
        answers = create_answers_ass(params)
        suggestions = SuggestionTAT.new({question_id: params[:question][:id]})
      when "tat"
        answers = create_answers_tat(params)
        suggestions = SuggestionASS.new({question_id: params[:question][:id], position: 'L'})
      end      
      score = score_calcul(answers, suggestions, params[:question][:type], params[:quiz_id])
      # On met à jour la session
      session = Session.new({id: params[:session_id]})
      score += session.find.score
      # avec les arrondis il peut arriver que le score dépasse 20 à 0.2 prés
      score = 100 if score > 100
      session = Session.new({id: params[:session_id], score: score})
      session.update

      # On retourne la réponse sous forme de hash
      {answers_created: answers}
    rescue => err
      LOGGER.error "Impossible de créer les nouvelles réponses ! message de l'erreur raise: "+err.message + err.backtrace.inspect
      {answer_created: {}, error:{msg: "La création des réponses a échoué !"}}
    end

    private 

    module_function

    def create_answers_qcm(params)
      answers = []
      params_answer = {
        session_id: params[:session_id]
      }
      params[:question][:answers].each do |answer|
        if answer[:id] && answer[:solution]
          params_answer[:left_suggestion_id] = answer[:id]
          new_answer = Answer.new(params_answer)
          answers.push(new_answer.create.to_hash)
        end
      end
      answers
    end

    def create_answers_tat(params)
      answers = []
      params_answer = {
        session_id: params[:session_id]
      }
      params[:question][:answers].each do |answer|
        if answer[:id] && answer[:solution][:id]
          params_answer[:left_suggestion_id] = answer[:id]
          params_answer[:right_suggestion_id] = answer[:solution][:id]
          new_answer = Answer.new(params_answer)
          answers.push(new_answer.create.to_hash)
        end
      end
      answers
    end

    def create_answers_ass(params)
      answers = []
      params_answer = {
        session_id: params[:session_id]
      }
      params[:question][:answers].each do |answer|
        if answer[:leftProposition][:id] 
          params_answer[:left_suggestion_id] = answer[:leftProposition][:id]
          answer[:leftProposition][:solutions].each do |solution|            
            params_answer[:right_suggestion_id] = params[:question][:answers][solution][:rightProposition][:id]
            new_answer = Answer.new(params_answer)
            answers.push(new_answer.create.to_hash)
          end
        end
      end
      answers
    end

    def score_calcul(answers, suggestions, type, quiz_id)
      nb_false_user = 0
      nb_correct_user = 0
      nb_correct_question = suggestions.find_all_solutions_ids.size
      answers.each do |answer|
        case type
        when 'qcm'
          solution = SolutionQCM.new({left_suggestion_id: answer[:left_suggestion_id]})
        when 'ass', 'tat'
          solution = Solution.new({left_suggestion_id: answer[:left_suggestion_id], right_suggestion_id: answer[:right_suggestion_id]})
        end
        if solution.find
          nb_correct_user += 1
        else
          nb_false_user += 1
        end
      end
      nb_response = suggestions.nb_responses_max
      score = 100 if nb_response == answers.size && nb_false_user == 0
      score = 0 if nb_response == answers.size && nb_false_user > 0
      if !score
        questions = Question.new({quiz_id: quiz_id})
        nb_questions = questions.find_all.count
        score = make_score(nb_correct_user, nb_false_user, nb_correct_question, nb_questions)
      end
      score
    end

    def make_score(nb_correct_user, nb_false_user, nb_correct_question, nb_questions)
      score = (Float(nb_correct_user) - (Float(nb_false_user) / 2)) / Float(nb_correct_question) * 100 / nb_questions
      score = 0 if score < 0
      score.round(1)
    end

    def delete_old_answers(params)
      old_answers = Answer.new({session_id: params[:session_id]})
      old_answers = old_answers.find_all_session_question(params[:question][:id])
      if old_answers && !old_answers.empty?
        case params[:question][:type]
        when "qcm"
          suggestions = SuggestionQCM.new({question_id: params[:question][:id]})
        when "ass"
          suggestions = SuggestionTAT.new({question_id: params[:question][:id]})
        when "tat"
          suggestions = SuggestionASS.new({question_id: params[:question][:id], position: 'L'})
        end

        old_answers_hash = []
        # on transforme les données des réponses en hash et on les supprime en même temps
        old_answers.each do |old_answer|
          old_answers_hash.push(old_answer.to_hash)
          old_answer.delete
        end

        session = Session.new({id: params[:session_id]})
        score = session.find.score
        score -= score_calcul(old_answers_hash, suggestions, params[:question][:type], params[:quiz_id])
        # avec les arrondis le score peut être en dessous de 0 à 0.2 prés
        score = 0 if score < 0
        # On met à jour la session
        session = Session.new({id: params[:session_id], score: score})
        session.update
      end
    end
  end
end