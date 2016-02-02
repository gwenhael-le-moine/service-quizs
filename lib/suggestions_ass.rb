module Lib
  module SuggestionsASS
    public

    module_function

    def self.get_all(question_id, read = false, marking = false, session_id = nil)
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
      solutions = []
      # On récupère toutes les suggestions
      suggestions = SuggestionASS.new(question_id: question_id)
      suggestions = suggestions.find_all.order(:order)
      suggestions.each do |suggestion|
        if suggestion.position == 'L'
          answers[suggestion.order][:leftProposition][:id] = suggestion.id
          answers[suggestion.order][:leftProposition][:libelle] = suggestion.text
          result = get_suggestion(suggestion, answers[suggestion.order][:leftProposition], solutions, read, marking, session_id)
          answers[suggestion.order][:leftProposition] = result[:answer]
          solutions = result[:solutions]
        else
          answers[suggestion.order][:rightProposition][:id] = suggestion.id
          answers[suggestion.order][:rightProposition][:libelle] = suggestion.text
          result = get_suggestion(suggestion, answers[suggestion.order][:rightProposition], solutions, read, marking, session_id)
          answers[suggestion.order][:rightProposition] = result[:answer]
        end
      end
      {answers: answers, solutions: solutions}
    end

    def self.create(quiz)
      order = 0
      # On créé en premier lieu toutes les propositions de droite
      params_suggestion = {
        question_id: quiz[:questions][0][:id]
      }
      quiz[:questions][0][:answers].each do |answer|

        params_suggestion[:order] = order
        params_suggestion[:position] = 'L'
        params_suggestion[:medium_id] = Lib::Medias.create(answer[:leftProposition][:joindre]) if answer[:leftProposition][:joindre][:type] == "video"
        answer[:leftProposition] = create_answer(answer[:leftProposition], params_suggestion)
        params_suggestion[:position] = 'R'
        params_suggestion[:medium_id] = Lib::Medias.create(answer[:rightProposition][:joindre]) if answer[:rightProposition][:joindre][:type] == "video"
        answer[:rightProposition] = create_answer(answer[:rightProposition], params_suggestion)
        order += 1
      end
      # Création des solutions
      quiz[:questions][0][:answers].each do |answer|
        params_suggestion[:order] = order
        create_solutions(quiz[:questions][0][:answers], answer)
      end
      quiz
    end

    def update(quiz)
      # on récupère les propositions existante de la BDD
      current_suggestion_ids = SuggestionASS.new(
        question_id: quiz[:questions][0][:id]
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
        response = update_answer(answer[:leftProposition], params_suggestion, current_suggestion_ids)
        answer[:leftProposition] = response[:answer]
        current_suggestion_ids = response[:current_suggestion_ids]
        params_suggestion[:position] = 'R'
        response = update_answer(answer[:rightProposition], params_suggestion, current_suggestion_ids)
        answer[:rightProposition] = response[:answer]
        current_suggestion_ids = response[:current_suggestion_ids]
        order += 1
      end
      # Suppression des proposition qui ne sont plus
      current_suggestion_ids.each do |id|
        suggestion = SuggestionASS.new(id: id)
        suggestion.delete
      end

      # on récupère les solutions
      current_solutions_ids = SuggestionASS.new(        question_id: quiz[:questions][0][:id],
                                                        position: 'L')
      current_solutions_ids = current_solutions_ids.find_all_solutions_ids
      quiz[:questions][0][:answers].each do |answer|
        if answer[:leftProposition][:libelle] && !answer[:leftProposition][:libelle].empty? && !answer[:leftProposition][:solutions].empty?
          current_solutions_ids = update_solutions(quiz[:questions][0][:answers], answer[:leftProposition], current_solutions_ids)
        end
      end
      # on supprime les solutions restantes
      current_solutions_ids.each do |id|
        solution = SolutionASS.new(id: id)
        solution.delete
      end
    end

    private

    module_function

    def get_suggestion(suggestion, answer, solutions, read = false, marking = false, session_id = nil)
      return {answer: answer, solutions: solutions} if read
      solutions_id = SuggestionASS.new(id: suggestion.id, position: suggestion.position)
      solutions_id = solutions_id.solution?(marking)
      if marking
        user_answers_id = Answer.new(session_id: session_id, left_suggestion_id: suggestion.id)
        user_answers_id = user_answers_id.find_all
        if suggestion.position == 'L'
          solutions.push(id: suggestion.id, solutions: solutions_id)
          answer[:solutions] = user_answers_id.map(:right_suggestion_id) if user_answers_id
        else
          answer[:solutions] = user_answers_id.map(:left_suggestion_id) if user_answers_id
        end
      else
        answer[:solutions] = solutions_id if solutions_id
      end
      {answer: answer, solutions: solutions}
    end

    # Création des proposition ASS
    def create_answer(answer, params_suggestion)
      if answer[:libelle] && !answer[:libelle].empty?
        params_suggestion[:text] = answer[:libelle]
        suggestion = SuggestionASS.new(params_suggestion)
        answer[:id] = suggestion.create.id
      end
      answer
    end

    # Création des solutions d'une proposition ASS
    def create_solutions(answers, answer)
      return unless answer[:leftProposition][:libelle] && !answer[:leftProposition][:libelle].empty? && !answer[:leftProposition][:solutions].empty?
      answer[:leftProposition][:solutions].each do |solution|
        params_solution = {
          left_suggestion_id: answer[:leftProposition][:id],
          right_suggestion_id: answers[solution][:rightProposition][:id]
        }
        association = SolutionASS.new(params_solution)
        association.create
      end
    end

    # Mise à jour d'une suggestion ass
    def update_answer(answer, params_suggestion, current_suggestion_ids)
      if answer[:libelle] && !answer[:libelle].empty?
        if answer[:id]
          current_suggestion_ids = current_suggestion_ids.delete_if { |id|
            id == answer[:id]
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
    def update_solutions(answers, answer, current_solutions_ids)
      answer[:solutions].each do |right_suggestion_position|
        right_suggestion_id = answers[right_suggestion_position][:rightProposition][:id]
        solution = SolutionASS.new(left_suggestion_id: answer[:id], right_suggestion_id: right_suggestion_id)
        solution_ass = solution.find
        if solution_ass
          current_solutions_ids = current_solutions_ids.delete_if { |id|
            id == solution_ass.id
          }
        else
          solution.create
        end
      end
      current_solutions_ids
    end
  end
end
