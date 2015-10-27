# encoding: utf-8
# génère les données différentes pour les cas de tests
def generate_test_data
  # Liste des quizs sequel
  quizs = []
  # génération d'un quiz non partagé mode entrainement
  # Quizs.unrestrict_primary_key
  quizs.push(Quizs.create(get_test_quiz({
    id: 0, 
    opt_show_score: 'after_each', 
    opt_show_correct: 'after_each',
    opt_can_redo: '1',
    opt_can_rewind: '1',
    opt_shared: '0'
  })))
  # génération d'un quiz non partagé mode exercice
  quizs.push(Quizs.create(get_test_quiz({
    id: 1,
    opt_show_score: 'at_end', 
    opt_show_correct: 'at_end',
    opt_can_redo: '0',
    opt_can_rewind: '0',
    opt_shared: '0'
  })))
  # génération d'un quiz non partagé mode évaluation
  quizs.push(Quizs.create(get_test_quiz({
    id: 2,
    opt_show_score: 'none', 
    opt_show_correct: 'none',
    opt_can_redo: '0',
    opt_can_rewind: '0',
    opt_shared: '0'
  })))
  # génération d'un quiz non partagé mode personalisé
  quizs.push(Quizs.create(get_test_quiz({
    id: 3,
    opt_show_score: 'after_each', 
    opt_show_correct: 'at_end',
    opt_can_redo: '0',
    opt_can_rewind: '1',
    opt_shared: '0'
  })))
  # génération d'un quiz partagé mode entrainement
  quizs.push(Quizs.create(get_test_quiz({
    id: 4,
    opt_show_score: 'after_each', 
    opt_show_correct: 'after_each',
    opt_can_redo: '1',
    opt_can_rewind: '1',
    opt_shared: '1'
  })))
  # génération d'un quiz non partagé mode exercice
  quizs.push(Quizs.create(get_test_quiz({
    id: 5,
    opt_show_score: 'at_end', 
    opt_show_correct: 'at_end',
    opt_can_redo: '0',
    opt_can_rewind: '0',
    opt_shared: '1'
  })))
  # génération d'un quiz non partagé mode évaluation
  quizs.push(Quizs.create(get_test_quiz({
    id: 6,
    opt_show_score: 'none', 
    opt_show_correct: 'none',
    opt_can_redo: '0',
    opt_can_rewind: '0',
    opt_shared: '1'
  })))
  # génération d'un quiz non partagé mode personalisé
  quizs.push(Quizs.create(get_test_quiz({
    id: 7,
    opt_show_score: 'at_end', 
    opt_show_correct: 'after_each',
    opt_can_redo: '0',
    opt_can_rewind: '1',
    opt_shared: '1'
  })))
  quizs
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

def delete_test_data( quizs )
  quizs.each do |quiz|
    quiz.delete
  end
end
