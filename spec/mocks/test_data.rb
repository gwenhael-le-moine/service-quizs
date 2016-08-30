# encoding: utf-8
# génère les données différentes pour les cas de tests
def generate_test_data(types = {})
  # Liste des quizs sequel
  quizs = []
  questions = []
  suggestions = []
  solutions = []
  publications = []
  sessions = []
  answers = []

  ########################### Les quizs ###############################
  if types[:quizs]
    # génération d'un quiz non partagé mode entrainement
    # Quizs.unrestrict_primary_key
    quizs.push(Quizs.create(get_test_quiz(      id: 0,
                                                opt_show_score: 'after_each',
                                                opt_show_correct: 'after_each',
                                                opt_can_redo: '1',
                                                opt_can_rewind: '1',
                                                opt_shared: '0')))
    # génération d'un quiz non partagé mode exercice
    quizs.push(Quizs.create(get_test_quiz(      id: 1,
                                                opt_show_score: 'at_end',
                                                opt_show_correct: 'at_end',
                                                opt_can_redo: '0',
                                                opt_can_rewind: '0',
                                                opt_shared: '0')))
    # génération d'un quiz non partagé mode évaluation
    quizs.push(Quizs.create(get_test_quiz(      id: 2,
                                                opt_show_score: 'none',
                                                opt_show_correct: 'none',
                                                opt_can_redo: '0',
                                                opt_can_rewind: '0',
                                                opt_shared: '0')))
    # génération d'un quiz non partagé mode personalisé
    quizs.push(Quizs.create(get_test_quiz(      id: 3,
                                                opt_show_score: 'after_each',
                                                opt_show_correct: 'at_end',
                                                opt_can_redo: '0',
                                                opt_can_rewind: '1',
                                                opt_shared: '0')))
    # génération d'un quiz partagé mode entrainement
    quizs.push(Quizs.create(get_test_quiz(      id: 4,
                                                opt_show_score: 'after_each',
                                                opt_show_correct: 'after_each',
                                                opt_can_redo: '1',
                                                opt_can_rewind: '1',
                                                opt_shared: '1')))
    # génération d'un quiz non partagé mode exercice
    quizs.push(Quizs.create(get_test_quiz(      id: 5,
                                                opt_show_score: 'at_end',
                                                opt_show_correct: 'at_end',
                                                opt_can_redo: '0',
                                                opt_can_rewind: '0',
                                                opt_shared: '1')))
    # génération d'un quiz non partagé mode évaluation
    quizs.push(Quizs.create(get_test_quiz(      id: 6,
                                                opt_show_score: 'none',
                                                opt_show_correct: 'none',
                                                opt_can_redo: '0',
                                                opt_can_rewind: '0',
                                                opt_shared: '1')))
    # génération d'un quiz non partagé mode personalisé
    quizs.push(Quizs.create(get_test_quiz(      id: 7,
                                                opt_show_score: 'at_end',
                                                opt_show_correct: 'after_each',
                                                opt_can_redo: '0',
                                                opt_can_rewind: '1',
                                                opt_shared: '1')))
  end

  ########################### Les questions ###############################
  if types[:quizs] && types[:questions]
    # génération d'une question QCM pour le quiz 0
    questions.push(Questions.create(get_test_question(      id: 0,
                                                            quiz_id: quizs[0].id,
                                                            type: 'QCM',
                                                            order: '0',
                                                            opt_rand_suggestion_order: false)))
    # génération d'une question ASS pour le quiz 0
    questions.push(Questions.create(get_test_question(      id: 1,
                                                            quiz_id: quizs[0].id,
                                                            type: 'ASS',
                                                            order: '1',
                                                            opt_rand_suggestion_order: true)))
    # génération d'une question TAT pour le quiz 0
    questions.push(Questions.create(get_test_question(      id: 2,
                                                            quiz_id: quizs[0].id,
                                                            type: 'TAT',
                                                            order: '2',
                                                            opt_rand_suggestion_order: true)))
  end

  ########################### Les suggestions ###############################
  if types[:quizs] && types[:questions] && types[:suggestions]
    # génération d'une suggestion QCM pour la question QCM 0
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 0,
                                                                  question_id: questions[0].id,
                                                                  position: 'L',
                                                                  order: 0)))
    # génération d'une suggestion QCM pour la question QCM 0
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 1,
                                                                  question_id: questions[0].id,
                                                                  position: 'L',
                                                                  order: 1)))
    # génération d'une suggestion gauche ASS pour la question ASS 1
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 2,
                                                                  question_id: questions[1].id,
                                                                  position: 'L',
                                                                  order: 0)))
    # génération d'une suggestion droite ASS pour la question ASS 1
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 3,
                                                                  question_id: questions[1].id,
                                                                  position: 'R',
                                                                  order: 0)))
    # génération d'une suggestion gauche ASS pour la question ASS 1
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 4,
                                                                  question_id: questions[1].id,
                                                                  position: 'L',
                                                                  order: 1)))
    # génération d'une suggestion gauche TAT pour la question TAT 2
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 5,
                                                                  question_id: questions[2].id,
                                                                  position: 'L')))
    # génération d'une suggestion droite TAT pour la question TAT 2
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 6,
                                                                  question_id: questions[2].id,
                                                                  position: 'R')))
    # génération d'un leurre TAT pour la question TAT 2
    suggestions.push(Suggestions.create(get_test_suggestion(      id: 7,
                                                                  question_id: questions[2].id,
                                                                  position: 'R')))
  end

  ########################### Les solutions ###############################
  if types[:quizs] && types[:questions] && types[:suggestions] && types[:solutions]
    # génération d'une solution QCM pour la sugestion QCM 0
    solutions.push(Solutions.create(get_test_solution(      left_suggestion_id: suggestions[0].id)))
    # génération d'une solution ASS pour la sugestion ASS 2 et ASS 3
    solutions.push(Solutions.create(get_test_solution(      left_suggestion_id: suggestions[2].id,
                                                            right_suggestion_id: suggestions[3].id)))
    # génération d'une solution TAT pour la sugestion TAT 5 et 6
    solutions.push(Solutions.create(get_test_solution(      left_suggestion_id: suggestions[5].id,
                                                            right_suggestion_id: suggestions[6].id)))
  end

  ######################### les publications ##################################
  if types[:quizs] && types[:publications]
    # Génération d'une publication pour le quiz 0
    to_date = Time.now + (60 * 60 * 24 * 7) # une semaine plus tard
    publications.push(Publications.create(get_test_publication(      quiz_id: quizs[0].id,
                                                                     rgpt_id: 1,
                                                                     from_date: Time.now.to_s(:db),
                                                                     to_date: to_date.to_s(:db),
                                                                     opt_show_score: quizs[0].opt_show_score,
                                                                     opt_show_correct: quizs[0].opt_show_correct,
                                                                     opt_can_redo: quizs[0].opt_can_redo,
                                                                     opt_can_rewind: quizs[0].opt_can_rewind,
                                                                     opt_rand_question_order: quizs[0].opt_rand_question_order)))
  end

  ######################### les sessions ##################################
  if types[:quizs] && types[:sessions]
    sessions.push(Sessions.create(get_test_session(      quiz_id: quizs[0].id,
                                                         user_id: 'VAA60000',
                                                         user_type: 'ENS',
                                                         score: 0)))

    sessions.push(Sessions.create(get_test_session(      quiz_id: quizs[0].id,
                                                         user_id: 'VAA60001',
                                                         user_type: 'ELV',
                                                         score: 15)))
  end

  ######################### les answers ##################################
  if types[:quizs] && types[:questions] && types[:suggestions] && types[:sessions] && types[:answers]
    answers.push(Answers.create(get_test_answer(      session_id: sessions[0].id,
                                                      left_suggestion_id: suggestions[0].id,
                                                      right_suggestion_id: nil)))
  end

  {quizs: quizs, questions: questions, suggestions: suggestions, solutions: solutions, publications: publications, sessions: sessions, answers: answers}
end

def get_test_quiz(params = {})
  uids = %w(VAA60000 VAA60001 VAA60002 VAA60003)
  quiz = {}
  quiz[:created_at] = Time.now.to_s(:db)
  quiz[:updated_at] = Time.now.to_s(:db)
  quiz[:user_id] = uids[params[:id].modulo(uids.size)]
  quiz[:title] = "Quiz numéro #{params[:id]}"
  quiz[:opt_show_score] = params[:opt_show_score]
  quiz[:opt_show_correct] = params[:opt_show_correct]
  quiz[:opt_can_redo] = params[:opt_can_redo]
  quiz[:opt_can_rewind] = params[:opt_can_rewind]
  quiz[:opt_rand_question_order] = '0'
  quiz[:opt_shared] = params[:opt_shared]

  quiz
end

def get_test_question(params = {})
  question = {}
  question[:quiz_id] = params[:quiz_id]
  question[:type] = params[:type]
  question[:question] = "Question numéro #{params[:id]}"
  question[:order] = params[:order]
  question[:opt_rand_suggestion_order] = params[:opt_rand_suggestion_order]
  question[:hint] = "Aide pour la question numéro #{params[:id]}"
  question[:correction_comment] = "Commentaire pour la correction de la question #{params[:id]}"

  question
end

def get_test_suggestion(params = {})
  suggestion = {}
  suggestion[:question_id] = params[:question_id]
  suggestion[:text] = "Suggestion numéro #{params[:id]} de la question"
  suggestion[:position] = params[:position]
  suggestion[:order] = params[:order]

  suggestion
end

def get_test_solution(params = {})
  solution = {}
  solution[:left_suggestion_id] = params[:left_suggestion_id]
  solution[:right_suggestion_id] = params[:right_suggestion_id]

  solution
end

def get_test_publication(params = {})
  publication = {}
  publication[:quiz_id] = params[:quiz_id]
  publication[:rgpt_id] = params[:rgpt_id]
  publication[:opt_show_score] = params[:opt_show_score]
  publication[:opt_show_correct] = params[:opt_show_correct]
  publication[:opt_can_redo] = params[:opt_can_redo]
  publication[:opt_can_rewind] = params[:opt_can_rewind]
  publication[:opt_rand_question_order] = params[:opt_rand_question_order]
  publication[:from_date] = params[:from_date]
  publication[:to_date] = params[:to_date]
  publication
end

def get_test_session(params = {})
  session = {}
  session[:quiz_id] = params[:quiz_id]
  session[:user_id] = params[:user_id]
  session[:user_type] = params[:user_type]
  session[:score] = params[:score]
  session[:created_at] = Time.now.to_s(:db)
  session
end

def get_test_answer(params = {})
  answer = {}
  answer[:session_id] = params[:session_id]
  answer[:left_suggestion_id] = params[:left_suggestion_id]
  answer[:right_suggestion_id] = params[:right_suggestion_id]
  answer[:created_at] = Time.now.to_s(:db)
  answer
end

def delete_test_data( datas )
  datas.each(&:delete)
end
