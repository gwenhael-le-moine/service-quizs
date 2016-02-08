module Lib
  module SuggestionsTAT
    public

    module_function

    # Récupère toutes les suggestions TAT de la question
    # read est le paramètre pour récupérer seulement les proposition gauche
    #      et toutes les propositions doites mélangées seulement pour le mode lecture du quiz
    # marking est le paramètre pour le mode correction,
    #         on récupère les réponse de l'élève et les solutions
    def self.get_all(question_id, read = false, marking = false, session_id = nil)
      answers = []
      leurres = []
      solutions = []
      # On récupère toutes les suggestions (textes, solutions et leurres)
      suggestions = SuggestionTAT.new(question_id: question_id)
      suggestions.find_all.each do |suggestion|
        # Si c'est la proposition de gauche (le texte)
        if suggestion.position == 'L'
          # On récupère la proposition de gauche
          result = get_left_suggestion(suggestion, read, marking, session_id, solutions)
          solutions = result[:solutions]
          answers.push(result[:answer])
        else
          unless marking
            is_solution = SuggestionTAT.new(id: suggestion.id, position: suggestion.position)
            is_solution = is_solution.solution?
            # on enregistre les leurres si on est pas en mode lecture
            leurres.push(format_right_suggestion(suggestion)) if !is_solution && !read
            # En mode lecture on retourne toutes les solutions avec les leurres mélangés
            solutions.push(format_right_suggestion(suggestion)) if read
          end
        end
      end
      {answers: answers, leurres: leurres, solutions: solutions}
    end

    def self.create(quiz)
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion = {
          question_id: quiz[:questions][0][:id],
          position: 'L',
          text: answer[:text]
        }
        create_answer(answer, params_suggestion)
      end
      # création des leurres
      quiz[:questions][0][:leurres].each do |leurre|
        params_leurre = {
          question_id: quiz[:questions][0][:id],
          position: 'R',
          text: leurre[:libelle]
        }
        suggestion = SuggestionTAT.new(params_leurre)
        leurre[:id] = suggestion.create.id
      end
      quiz
    end

    # Mise à jour des suggestions/solution TAT
    def self.update(quiz)
      # on récupère tous les leurres de la question en base
      suggestions = SuggestionTAT.new(question_id: quiz[:questions][0][:id])
      current_leurre_ids = suggestions.find_all_leurres_ids
      # On récupère toutes les suggestions qui sont solutions
      current_suggestion_ids = suggestions.find_all_ids
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion = {
          id: answer[:id],
          question_id: quiz[:questions][0][:id],
          position: 'L',
          text: answer[:text]
        }
        # Si la suggestion à un texte et un id on update
        # Sinon on créé
        if answer[:text] && !answer[:text].empty?
          if answer[:id]
            answer[:joindre] = Lib::Medias.update(answer[:joindre], answer[:id], "suggestion") if answer[:joindre][:type] == 'video'
            current_suggestion_ids = update_answer(answer, params_suggestion, current_suggestion_ids)
          else
            create_answer(answer, params_suggestion)
          end
        end
      end
      # Pour chaque leurre, si l'id est un id temp, c'est une création
      quiz[:questions][0][:leurres].each do |l|
        params_leurre = {
          id: l[:id],
          question_id: quiz[:questions][0][:id],
          position: 'R',
          text: l[:libelle],
          meduim_id: nil
        }
        leurre = SuggestionTAT.new(params_leurre)
        leurre.create unless current_leurre_ids.include?(l[:id])
        current_leurre_ids.delete_if { |id| id == l[:id] }
      end
      # on supprime les anciennes suggestions non trouvé dans la mise à jour
      current_suggestion_ids.each do |id|
        suggestion = SuggestionTAT.new(id: id)
        suggestion.delete
      end
      current_leurre_ids.each do |id|
        suggestion = SuggestionTAT.new(id: id)
        suggestion.delete
      end
    end

    private

    module_function

    def get_left_suggestion(suggestion, read = false, marking = false, session_id = nil, solutions = [])
      answer = format_left_suggestion(suggestion)
      answer[:joindre] = Lib::Medias.get(suggestion.id, "suggestion")
      # Si on n'est pas dans le mode lecture
      unless read
        solution_id = SuggestionTAT.new(id: suggestion.id, position: suggestion.position)
        solution_id = solution_id.solution?
        # On récupère la solution et dans le mode correction, la réponse de l'utilisateur
        if marking
          user_answer_id = Answer.new(session_id: session_id, left_suggestion_id: suggestion.id)
          user_answer_id = user_answer_id.find_all.first
          # Réponse de l'élève
          if user_answer_id
            answer[:solution] = get_right_suggestion(user_answer_id.right_suggestion_id)
          else
            answer[:solution] = nil
          end
          # Solution exacte de la suggestion
          solutions.push(id: suggestion.id, solution: get_right_suggestion(solution_id)) if solution_id
        else
          answer[:solution] = get_right_suggestion(solution_id) if solution_id
        end
      end
      {answer: answer, solutions: solutions}
    end

    def get_right_suggestion(right_suggestion_id)
      answer = {}
      if right_suggestion_id
        right_suggestion = SuggestionTAT.new(id: right_suggestion_id)
        right_suggestion = right_suggestion.find
        answer = format_right_suggestion(right_suggestion)
      end
      answer
    end

    def format_left_suggestion(suggestion)
      {
        id: suggestion.id,
        text: suggestion.text,
        joindre: {file: nil, type: nil},
        solution: {id: nil, libelle: nil}
      }
    end

    def format_right_suggestion(suggestion)
      {
        id: suggestion.id,
        libelle: suggestion.text
      }
    end

    def create_answer(answer, params_suggestion)
      # création de la suggestion qcm
      suggestion = SuggestionTAT.new(params_suggestion)
      answer[:id] = suggestion.create.id
      answer[:joindre][:id] = Lib::Medias.create(answer[:joindre], answer[:id], "suggestion") if answer[:joindre][:type] == "video"
      # création de la solution s'il elle l'est
      if answer[:solution][:libelle]
        params_response = {
          question_id: params_suggestion[:question_id],
          position: 'R',
          text: answer[:solution][:libelle]
        }
        response = SuggestionTAT.new(params_response)
        answer[:solution][:id] = response.create.id
        solution = SolutionTAT.new(left_suggestion_id: answer[:id], right_suggestion_id: answer[:solution][:id])
        solution.create
      end
      answer
    end

    # Mise à jour d'une suggestion/solution TAT
    def update_answer(answer, params_suggestion, current_suggestion_ids)
      # Afin de supprimer les suggestions qui ne sont plus,
      # on supprime l'id de la suggestion de la liste si on le trouve
      current_suggestion_ids = current_suggestion_ids.delete_if { |id| id == answer[:id] }
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
        current_suggestion_ids = current_suggestion_ids.delete_if { |id| id == answer[:solution][:id] }
        response.update
      end
      # si on a un libelle mais pas d'id cela veut dire que c'est une nouvelle solution
      if answer[:solution][:libelle] && !answer[:solution][:libelle].empty? && !answer[:solution][:id]
        answer[:solution][:id] = response.create.id
        solution = SolutionTAT.new(left_suggestion_id: answer[:id], right_suggestion_id: answer[:solution][:id])
        solution.create
      end
      current_suggestion_ids
    end
  end
end
