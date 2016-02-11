module Lib
  module SuggestionsQCM
    public

    module_function

    def self.get_all(question_id, read = false, marking = false, session_id = nil)
      answers = [
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}},
        {solution: false, proposition: '', joindre: {file: nil, type: nil}}
      ]
      solutions = []
      suggestions = SuggestionQCM.new(question_id: question_id)
      suggestions.find_all.each do |suggestion|
        answers[suggestion.order][:id] = suggestion.id
        answers[suggestion.order][:proposition] = suggestion.text
        answers[suggestion.order][:joindre] = Lib::Medias.get(suggestion.id, 'suggestion')
        is_solution = SuggestionQCM.new(id: suggestion.id) unless read
        if marking
          solutions.push(suggestion.id) if is_solution.solution?
          is_solution = Answer.new(session_id: session_id, left_suggestion_id: suggestion.id)
          answers[suggestion.order][:solution] = !is_solution.find_all.empty?
        else
          answers[suggestion.order][:solution] = is_solution.solution? unless read
        end
      end
      {answers: answers, solutions: solutions}
    end

    # Création de toutes les suggestions/solutions de la question QCM
    def self.create(quiz)
      # order des suggestions
      order = 0
      quiz[:questions][0][:answers].each do |answer|
        if answer[:proposition] && !answer[:proposition].empty?
          params_suggestion = {
            question_id: quiz[:questions][0][:id],
            text: answer[:proposition],
            order: order
          }
          answer = create_answer(answer, params_suggestion)
          order += 1
          answer[:joindre][:id] = Lib::Medias.create(answer[:joindre], answer[:id], 'suggestion') if answer[:joindre][:type] == 'video'
        end
      end
      quiz
    rescue => err
      LOGGER.error err.message + ' =====> ' + err.backtrace.inspect
    end

    # Mise à jour des suggestions/solutions QCM
    def self.update(quiz)
      # on récupère les ids des suggestions existante à la question
      current_suggestion_ids = SuggestionQCM.new(question_id: quiz[:questions][0][:id])
      current_suggestion_ids = current_suggestion_ids.find_all_ids
      order = 0
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion = {
          id: answer[:id],
          question_id: quiz[:questions][0][:id],
          text: answer[:proposition],
          order: order
        }
        if answer[:proposition] && !answer[:proposition].empty?
          # Si on à un id c'est une mise à jour
          if answer[:id]
            answer[:joindre] = Lib::Medias.update(answer[:joindre], answer[:id], 'suggestion') if answer[:joindre][:type] == 'video'
            current_suggestion_ids = update_answer(answer, params_suggestion, current_suggestion_ids)
          else
            create_answer(answer, params_suggestion)
          end
        end
        order += 1
      end
      # On supprime les suggestions qui ne sont plus dans la question
      current_suggestion_ids.each do |id|
        suggestion = SuggestionQCM.new(id: id)
        suggestion.delete
      end
    end

    private

    module_function

    # Création d'une suggestion/solution QCM
    def create_answer(answer, params_suggestion)
      # création de la suggestion qcm
      suggestion = SuggestionQCM.new(params_suggestion)
      answer[:id] = suggestion.create.id
      # création de la solution s'il elle l'est
      if answer[:solution]
        solution = SolutionQCM.new(left_suggestion_id: answer[:id])
        solution.create
      end
      answer
    end

    # Mise à jour d'une suggestion/solution QCM
    def update_answer(answer, params_suggestion, current_suggestion_ids)
      # Afin de supprimer les suggestions qui ne sont plus,
      # on supprime l'id de la suggestion de la liste si on le trouve
      current_suggestion_ids = current_suggestion_ids.delete_if { |id| id == answer[:id] }
      suggestion = SuggestionQCM.new(params_suggestion)
      # On regarde si la suggestion est solution
      is_solution = suggestion.solution?
      # On met à jour les infos de la suggestion
      suggestion.update
      solution = SolutionQCM.new(left_suggestion_id: answer[:id])
      # S'il n'y a plus de solution on doit la supprimer
      solution.delete if is_solution != answer[:solution] && is_solution == true
      # Si on contraire maintenant elle est solution,
      # On la créé
      solution.create if is_solution != answer[:solution] && is_solution == false
      current_suggestion_ids
    end
  end
end
