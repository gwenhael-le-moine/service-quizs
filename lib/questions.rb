# -*- coding: utf-8 -*-
# Module pour les Quizs

module Lib
  module Questions
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

    # Fonction qui récupère une question et ses réponses
    # read permet d récupérer seulement les suggestions sans les solutions
    def self.get(question_id, read = false)
      question = Question.new({id: question_id})
      question = question.find
      question_found = {
        id: question.id,
        type: question.type.downcase,
        libelle: question.question,
        media: {file: nil, type: nil},
        hint: {libelle:question.hint, media: {file: nil, type: nil}},
        randanswer: question.opt_rand_suggestion_order,
        answers: [],
        leurres: [],
        comment: question.correction_comment,
        sequence: question.order
      }
      case question.type
      when "QCM"
        question_found[:answers] = get_all_suggestions_qcm(question_id, read)
      when "TAT"
        response = get_all_suggestions_tat(question_id, read)
        question_found[:answers] = response[:answers]
        question_found[:solutions] = response[:solutions] if read
        question_found[:leurres] = response[:leurres] if !read
      when "ASS"
        question_found[:answers] = get_all_suggestions_ass(question_id, read)
      end      
      {question_found: question_found}
    rescue => err
      LOGGER.error err.message + "     " + err.backtrace.inspect
    end

    # Fonction qui récupère toutes les questions d'un quiz
    def self.get_all(quiz_id, read = false)
      questions_found = []
      questions = Question.new({quiz_id: quiz_id})
      questions = questions.find_all
      questions.each do |question|
        if read
          questions_found.push(self.get(question.id, read)[:question_found])
        else
          questions_found.push({
            id: question.id,
            type: question.type,
            libelle: question.question,
            sequence: question.order
          })          
        end
      end
      questions_found.sort_by! { |e| e[:sequence]   }
      {questions_found: questions_found}
    rescue => err
      LOGGER.error err.message + err.backtrace.inspect
    end

    # Fonction qui créé une question avec leurs suggestions et solutions
    def self.create(quiz)
      order = Question.new({quiz_id: quiz[:id]})
      order = order.find_all.count
      if @user[:uid] == quiz[:user_id]
        #TODO: Création des médias
        # création de la question
        params_question = {
          quiz_id: quiz[:id],
          type: quiz[:questions][0][:type].upcase,
          question: quiz[:questions][0][:libelle],
          order: order,
          opt_rand_suggestion_order: quiz[:questions][0][:randanswer],
          hint: quiz[:questions][0][:hint][:libelle],
          correction_comment: quiz[:questions][0][:comment],
          meduim_id: nil
        }
        question = Question.new(params_question)
        quiz[:questions][0][:id] = question.create.id

        # Création des suggestions
        case quiz[:questions][0][:type]
        when "qcm"
          quiz[:questions][0][:answers] = create_answers_qcm(quiz)
        when "tat"
          quiz[:questions][0] = create_answers_tat(quiz)
        when "ass"
          quiz[:questions][0][:answers] = create_answers_ass(quiz)
        end
        {question_created: quiz[:questions][0]}
      end
    rescue => err
      LOGGER.error "Impossible de créer la nouvelle question ! message de l'erreur raise: "+err.message + "   " + err.backtrace.inspect
      {question_created: {}, error:{msg: "La création de la question a échoué !"}}
    end

    # Mise à jour de la question
    def self.update(quiz)
      if @user[:uid] == quiz[:user_id]
        params_question = {
          id: quiz[:questions][0][:id],
          question: quiz[:questions][0][:libelle],
          hint: quiz[:questions][0][:hint][:libelle],
          correction_comment: quiz[:questions][0][:comment],
          order: quiz[:questions][0][:sequence],
          meduim_id: nil
        }
        question = Question.new(params_question)
        question = question.find
        if quiz[:questions][0][:type].downcase != question.type.downcase
          question.delete
          quiz[:questions][0] = self.create(quiz)[:question_created]
        else
          question = Question.new(params_question)
          question.update
          # mise à jour des suggestions
          case quiz[:questions][0][:type]
          when "qcm"
            update_answers_qcm(quiz)
          when "tat"
            update_answers_tat(quiz)
          when "ass"
            update_answers_ass(quiz)
          end
        end
        {question_updated: quiz[:questions][0]}
      end
    rescue => err
      LOGGER.error "Impossible de mettre à jour la question ! message de l'erreur raise: "+err.message + "   " + err.backtrace.inspect
      {question_updated: {}, error:{msg: "La mise à jour de la question a échoué !"}}
    end

    def self.update_order(quiz)
      if @user[:uid] == quiz[:user_id]
        quiz[:questions].each do |question|
          question_updated = Question.new({id: question[:id], order: question[:sequence]})
          question_updated.update
        end
        {questions_updated: quiz[:questions]}
      end
    rescue => err
      LOGGER.error "Impossible de mettre à jour l'odre des questions ! message de l'erreur raise: "+err.message + "   " + err.backtrace.inspect
      {questions_updated: [], error:{msg: "La mise à jour de l'ordre de la question a échoué !"}}
    end

    # Suppression de la question
    def self.delete(question_id)
      question = Question.new({id: question_id})
      question_deleted = question.delete
      {question_deleted: question_deleted}
    rescue => err
      LOGGER.error "Impossible de supprimer la question ! message de l'erreur raise: "+err.message
      {question_created: {}, error:{msg: "La suppression de la question a échoué !"}}
    end

    private

    module_function

    def get_all_suggestions_qcm(question_id, read = false)
      answers = [
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}},
        {solution: false, proposition: "", joindre: {file: nil, type: nil}}
      ]
      suggestions = SuggestionQCM.new({question_id: question_id})
      suggestions.find_all.each do |suggestion|
        answers[suggestion.order][:id] = suggestion.id
        answers[suggestion.order][:proposition] = suggestion.text
        if !read
          is_solution = SuggestionQCM.new({id: suggestion.id})
          answers[suggestion.order][:solution] = is_solution.solution?          
        end
      end
      answers
    end

    def get_all_suggestions_tat(question_id, read = false)
      answers = []
      leurres = []
      solutions = []
      # On récupère toutes les suggestions (textes, solutions et leurres)
      suggestions = SuggestionTAT.new({question_id: question_id})
      suggestions.find_all.each do |suggestion|
        # On regarde s'il a une solution
        is_solution = SuggestionTAT.new({id: suggestion.id, position: suggestion.position})
        solution_id = is_solution.solution?
        # Si c'est la proposition de gauche (le texte)
        if suggestion.position == 'L'
          answer = {
            id: suggestion.id,
            text: suggestion.text,
            joindre: {file: nil, type: nil},
            solution: {id: nil, libelle: nil}
          }
          # Si il y a une solution, on la récupère (proposition droite)
          if solution_id && !read
            solution = SuggestionTAT.new({id: solution_id})
            solution = solution.find
            answer[:solution][:id] = solution.id
            answer[:solution][:libelle] = solution.text
          end
          answers.push(answer)
        else
          # Sinon si c'est une proposition droite 
          # et qu'elle n'est pas solution, c'est un leurre
          if !solution_id && !read
            leurres.push({
              id: suggestion.id,
              libelle: suggestion.text
            }) 
          elsif read
            solutions.push({
              id: suggestion.id,
              libelle: suggestion.text
            })
          end          
        end
      end
      {answers: answers, leurres: leurres, solutions: solutions}
    end

    def get_all_suggestions_ass(question_id, read = false)
      answers = [
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        },
        {
          leftProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}, 
          rightProposition: {libelle: nil, joindre: {file: nil, type: nil}, solutions: []}
        }
      ]
      # On récupère toutes les suggestions
      suggestions = SuggestionASS.new({question_id: question_id})
      suggestions.find_all.each do |suggestion|
        is_solution = SuggestionASS.new({id: suggestion.id, position: suggestion.position})
        solutions = is_solution.solution? 
        if suggestion.position == 'L'
          answers[suggestion.order][:leftProposition][:id] = suggestion.id
          answers[suggestion.order][:leftProposition][:libelle] = suggestion.text
          answers[suggestion.order][:leftProposition][:solutions] = solutions if solutions && !read
        else
          answers[suggestion.order][:rightProposition][:id] = suggestion.id
          answers[suggestion.order][:rightProposition][:libelle] = suggestion.text
          answers[suggestion.order][:rightProposition][:solutions] = solutions if solutions && !read
        end
      end
      answers
    end
    # Création de toutes les suggestions/solutions de la question QCM
    def create_answers_qcm(quiz)
      # order des suggestions
      order = 0
      quiz[:questions][0][:answers].each do |answer|
        if answer[:proposition] && !answer[:proposition].empty?
          params_suggestion = {
            question_id: quiz[:questions][0][:id],
            text: answer[:proposition],
            order: order,
            meduim_id: nil
          }
          answer = create_answer_qcm(answer, params_suggestion)
          order += 1
        end
      end
      quiz[:questions][0][:answers]
    end

    # Création d'une suggestion/solution QCM
    def create_answer_qcm(answer, params_suggestion)
      # création de la suggestion qcm
      suggestion = SuggestionQCM.new(params_suggestion)
      answer[:id] = suggestion.create.id
      # création de la solution s'il elle l'est
      if answer[:solution]
        solution = SolutionQCM.new({left_suggestion_id: answer[:id]})
        solution.create
      end
      answer
    end


    def create_answers_tat(quiz)
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion = {
          question_id: quiz[:questions][0][:id],
          position: 'L',
          text: answer[:text],
          meduim_id: nil
        }
        answer = create_answer_tat(answer, params_suggestion)
      end
      # crétaion des leurres
      quiz[:questions][0][:leurres].each do |leurre|
        params_leurre = {
          question_id: quiz[:questions][0][:id],
          position: 'R',
          text: leurre[:libelle]
        }
        suggestion = SuggestionTAT.new(params_leurre)
        leurre[:id] = suggestion.create.id
      end
      quiz[:questions][0]
    end

    def create_answer_tat(answer, params_suggestion)
      # création de la suggestion qcm
      suggestion = SuggestionTAT.new(params_suggestion)
      answer[:id] = suggestion.create.id
      # création de la solution s'il elle l'est
      if answer[:solution][:libelle]
        params_response = {
          question_id: params_suggestion[:question_id],
          position: 'R',
          text: answer[:solution][:libelle]
        }
        response = SuggestionTAT.new(params_response)
        answer[:solution][:id] = response.create.id
        solution = SolutionTAT.new({left_suggestion_id: answer[:id], right_suggestion_id: answer[:solution][:id]})
        solution.create
      end
      answer
    end

    def create_answers_ass(quiz)
      order = 0
      # On créé en premier lieu toutes les propositions de droite
      params_suggestion = {
        question_id: quiz[:questions][0][:id],
        meduim_id: nil
      }
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion[:order] = order 
        params_suggestion[:position] = 'L'       
        answer[:leftProposition] = create_answer_ass(answer[:leftProposition], params_suggestion)
        params_suggestion[:position] = 'R'       
        answer[:rightProposition] = create_answer_ass(answer[:rightProposition], params_suggestion)
        order += 1
      end
      # Création des solutions
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion[:order] = order
        create_solutions_ass(quiz[:questions][0][:answers], answer)
      end
    end

    # Création des proposition ASS
    def create_answer_ass(answer, params_suggestion)
      if answer[:libelle] && !answer[:libelle].empty?
        params_suggestion[:text] = answer[:libelle]
        suggestion = SuggestionASS.new(params_suggestion)
        answer[:id] = suggestion.create.id
      end
      answer
    end

    # Création des solutions d'une proposition ASS
    def create_solutions_ass(answers, answer)
      if answer[:leftProposition][:libelle] && !answer[:leftProposition][:libelle].empty? && !answer[:leftProposition][:solutions].empty?
        answer[:leftProposition][:solutions].each do |solution|
          params_solution = {
            left_suggestion_id: answer[:leftProposition][:id],
            right_suggestion_id: answers[solution][:rightProposition][:id]
          }
          association = SolutionASS.new(params_solution)
          association.create
        end
      end
    end

    # Mise à jour des suggestions/solutions QCM
    def update_answers_qcm(quiz)
      # on récupère les ids des suggestions existante à la question
      current_suggestion_ids = SuggestionQCM.new({question_id: quiz[:questions][0][:id]})
      current_suggestion_ids = current_suggestion_ids.find_all_ids
      order = 0
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion = {
          id: answer[:id],
          question_id: quiz[:questions][0][:id],
          text: answer[:proposition],
          order: order,
          meduim_id: nil
        }
        if answer[:proposition] && !answer[:proposition].empty?
          # Si on à un id c'est une mise à jour
          if answer[:id]
            update_answer_qcm(answer, params_suggestion, current_suggestion_ids)            
          else
            answer = create_answer_qcm(answer, params_suggestion)
          end
        end
        order += 1
      end
      # On supprime les suggestions qui ne sont plus dans la question
      current_suggestion_ids.each do |id|
        suggestion = SuggestionQCM.new({id: id})
        suggestion.delete
      end
    end

    # Mise à jour d'une suggestion/solution QCM
    def update_answer_qcm(answer, params_suggestion, current_suggestion_ids)
      # Afin de supprimer les suggestions qui ne sont plus,
      # on supprime l'id de la suggestion de la liste si on le trouve
      current_suggestion_ids = current_suggestion_ids.delete_if {|id| id == answer[:id]}
      suggestion = SuggestionQCM.new(params_suggestion)
      # On regarde si la suggestion est solution
      is_solution = suggestion.solution?
      # On met à jour les infos de la suggestion
      suggestion.update
      solution = SolutionQCM.new({left_suggestion_id: answer[:id]})
      # S'il n'y a plus de solution on doit la supprimer
      solution.delete if is_solution != answer[:solution] && is_solution == true
      # Si on contraire maintenant elle est solution,
      # On la créé
      solution.create if is_solution != answer[:solution] && is_solution == false
    end

    # Mise à jour des suggestions/solution TAT 
    def update_answers_tat(quiz)
      # on récupère tous les leurres de la question en base
      suggestions = SuggestionTAT.new({question_id: quiz[:questions][0][:id]})
      current_leurre_ids = suggestions.find_all_leurres_ids
      # On récupère toutes les suggestions qui sont solutions
      current_suggestion_ids = suggestions.find_all_ids
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion = {
          id: answer[:id],
          question_id: quiz[:questions][0][:id],
          position: 'L',
          text: answer[:text],
          meduim_id: nil
        }
        # Si la suggestion à un texte et un id on update
        # Sinon on créé
        if answer[:text] && !answer[:text].empty?
          if answer[:id]
            current_suggestion_ids = update_answer_tat(answer, params_suggestion, current_suggestion_ids)
          else
            answer = create_answer_tat(answer, params_suggestion)
          end          
        end
      end
      # Pour chaque leurre, si l'id est un id temp, c'est une création
      quiz[:questions][0][:leurres].each  do |l|
        params_leurre = {
          id: l[:id],
          question_id: quiz[:questions][0][:id],
          position: 'R',
          text: l[:libelle],
          meduim_id: nil
        }
        leurre = SuggestionTAT.new(params_leurre)
        leurre.create if !current_leurre_ids.include?(l[:id])
        current_leurre_ids.delete_if {|id| id == l[:id]}
      end
      # on supprime les anciennes suggestions non trouvé dans la mise à jour
      current_suggestion_ids.each do |id|
        suggestion = SuggestionTAT.new({id: id})
        suggestion.delete
      end
      current_leurre_ids.each do |id|
        suggestion = SuggestionTAT.new({id: id})
        suggestion.delete
      end
    end

    #Mise à jour d'une suggestion/solution TAT
    def update_answer_tat(answer, params_suggestion, current_suggestion_ids)
      # Afin de supprimer les suggestions qui ne sont plus,
      # on supprime l'id de la suggestion de la liste si on le trouve
      current_suggestion_ids = current_suggestion_ids.delete_if {|id| id == answer[:id]}
      suggestion = SuggestionTAT.new(params_suggestion)
      # On regarde si la suggestion est solution
      is_solution = suggestion.solution?
      # On met à jour les infos de la suggestion
      suggestion.update
      params_response = {
        id: answer[:solution][:id],
        question_id: params_suggestion[:question_id],
        position: 'R',
        text: answer[:solution][:libelle]
      }
      response = SuggestionTAT.new(params_response)
      # S'il on a un libelle et l'id correspond on met a jour la solution
      if answer[:solution][:libelle] && !answer[:solution][:libelle].empty? && answer[:solution][:id] == is_solution
        current_suggestion_ids = current_suggestion_ids.delete_if {|id| id == answer[:solution][:id]}
        response.update
      end 
      # si on a un libelle mais pas d'id cela veut dire que c'est une nouvelle solution
      if answer[:solution][:libelle] && !answer[:solution][:libelle].empty? && !answer[:solution][:id]
        answer[:solution][:id] = response.create.id
        solution = SolutionTAT.new({left_suggestion_id: answer[:id], right_suggestion_id: answer[:solution][:id]})
        solution.create
      end
      current_suggestion_ids
    end

    def update_answers_ass(quiz)
      # on récupère les propositions existante de la BDD
      current_suggestion_ids = SuggestionASS.new(
        {question_id: quiz[:questions][0][:id]}
      )
      current_suggestion_ids = current_suggestion_ids.find_all_ids
      # On met à jour les propositions
      params_suggestion = {
        question_id: quiz[:questions][0][:id],
        meduim_id: nil
      }
      order = 0
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion[:order] = order
        params_suggestion[:position] = 'L'
        response = update_answer_ass(answer[:leftProposition], params_suggestion, current_suggestion_ids)
        answer[:leftProposition] = response[:answer]
        current_suggestion_ids = response[:current_suggestion_ids]
        params_suggestion[:position] = 'R'
        response = update_answer_ass(answer[:rightProposition], params_suggestion, current_suggestion_ids)
        answer[:rightProposition] = response[:answer]
        current_suggestion_ids = response[:current_suggestion_ids]
        order += 1
      end
      # Suppression des proposition qui ne sont plus
      current_suggestion_ids.each do |id|
        suggestion = SuggestionASS.new({id: id})
        suggestion.delete
      end

      # on récupère les solutions
      current_solutions_ids = SuggestionASS.new({
        question_id: quiz[:questions][0][:id],
        position: 'L'
      })
      current_solutions_ids = current_solutions_ids.find_all_solutions_ids
      quiz[:questions][0][:answers].each do |answer|
        if answer[:leftProposition][:libelle] && !answer[:leftProposition][:libelle].empty? && !answer[:leftProposition][:solutions].empty?
          current_solutions_ids = update_solutions_ass(quiz[:questions][0][:answers], answer[:leftProposition], current_solutions_ids)
        end
      end
      # on supprime les solutions restantes
      current_solutions_ids.each do |id|
        solution = SolutionASS.new({id: id})
        solution.delete
      end
    end

    # Mise à jour d'une suggestion ass    
    def update_answer_ass(answer, params_suggestion, current_suggestion_ids)
      if answer[:libelle] && !answer[:libelle].empty?
        if answer[:id]
          current_suggestion_ids = current_suggestion_ids.delete_if {
            |id| id == answer[:id]
          }
          params_suggestion[:id] = answer[:id]
          params_suggestion[:text] = answer[:libelle]
          suggestion = SuggestionASS.new(params_suggestion)
          suggestion.update
        else
          create_answer_ass(answer, params_suggestion)
        end         
      end
      {current_suggestion_ids: current_suggestion_ids, answer: answer}
    end

    # Création des nouvelles solutions
    def update_solutions_ass(answers, answer, current_solutions_ids)
      answer[:solutions].each do |right_suggestion_position|
        right_suggestion_id = answers[right_suggestion_position][:rightProposition][:id]
        solution = SolutionASS.new({left_suggestion_id: answer[:id], right_suggestion_id: right_suggestion_id})
        solution_ass = solution.find
        if solution_ass
          current_solutions_ids = current_solutions_ids.delete_if {
            |id| id == solution_ass.id
          }
        else
          solution.create
        end
      end
      current_solutions_ids
    end
  end
end
