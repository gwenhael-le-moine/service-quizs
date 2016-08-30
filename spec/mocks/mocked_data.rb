# -*- coding: utf-8 -*-
MOCKED_DATA = {
  user: 'erasme',
  is_logged: true,
  uid: 'VAA60000',
  login: 'erasme',
  sexe: 'M',
  nom: 'Levallois',
  prenom: 'Pierre-Gilles',
  date_naissance: '1970-02-06',
  adresse: '1 rue Sans Nom Propre',
  code_postal: '69000',
  ville: 'Lyon',
  bloque: nil,
  id_jointure_aaf: nil,
  avatar: '',
  roles_max_priority_etab_actif: 3,
  user_detailed: {
    'id' => 1,
    'id_sconet' => nil,
    'login' => 'erasme',
    'id_jointure_aaf' => nil,
    'nom' => 'Levallois',
    'prenom' => 'Pierre-Gilles',
    'sexe' => 'M',
    'id_ent' => 'VAA60000',
    'date_naissance' => '1970-02-06',
    'adresse' => '1 rue Sans Nom Propre',
    'code_postal' => '69000',
    'ville' => 'Lyon',
    'avatar' => '',
    'full_name' => 'Levallois Pierre-gilles',
    'profil_actif' => {
      'profil_id' => 'ENS',
      'etablissement_nom' => 'ERASME',
      'etablissement_code_uai' => '0699990Z',
      'profil_nom' => 'Enseignant',
      'profil_code_national' => 'National_ENS',
      'etablissement_id' => 1,
      'actif' => true,
      'bloque' => nil
    },
    'profils' => [
      {
        'profil_id' => 'ENS',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'profil_nom' => 'Enseignant',
        'profil_code_national' => 'National_ENS',
        'etablissement_id' => 1,
        'actif' => true,
        'bloque' => nil
      },
      {
        'profil_id' => 'ELV',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'profil_nom' => 'Elève',
        'profil_code_national' => 'National_ELV',
        'etablissement_id' => 1,
        'actif' => false,
        'bloque' => nil
      }
    ],
    'roles' => [
      {
        'role_id' => 'ADM_ETB',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 2,
        'libelle' => "Administrateur d'établissement"
      },
      {
        'role_id' => 'ELV_ETB',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 0,
        'libelle' => 'Elève'
      },
      {
        'role_id' => 'PROF_ETB',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 1,
        'libelle' => 'Professeur'
      },
      {
        'role_id' => 'TECH',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 3,
        'libelle' => 'Administrateur technique'
      }
    ],
    'emails' => [ ],
    'roles_max_priority_etab_actif' => 3,
    'etablissements' => [
      {
        'id' => 1,
        'nom' => 'ERASME',
        'code_uai' => '0699990Z',
        'profils' => [
          {
            'profil_id' => 'ELV',
            'user_id' => 1,
            'etablissement_id' => 1,
            'bloque' => nil,
            'actif' => false
          },
          {
            'profil_id' => 'ENS',
            'user_id' => 1,
            'etablissement_id' => 1,
            'bloque' => nil,
            'actif' => true
          }
        ],
        'roles' => [
          {
            'role_id' => 'ADM_ETB',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 2,
            'libelle' => "Administrateur d'établissement"
          },
          {
            'role_id' => 'ELV_ETB',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 0,
            'libelle' => 'Elève'
          },
          {
            'role_id' => 'PROF_ETB',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 1,
            'libelle' => 'Professeur'
          },
          {
            'role_id' => 'TECH',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 3,
            'libelle' => 'Administrateur technique'
          }
        ]
      }
    ],
    'classes' => [
      {
        'etablissement_code' => '0690078K',
        'classe_libelle' => '6B',
        'etablissement_nom' => "CLG-VAL D'ARGENT",
        'matiere_enseignee_id' => '003700',
        'matiere_libelle' => 'AIDE ET ACCOMPAGNEMENT TRAVAIL PERSONNEL',
        'classe_id' => 1,
        'etablissement_id' => 1348,
        'prof_principal' => 'N'
      },
      {
        'etablissement_code' => '0690078K',
        'classe_libelle' => '5A',
        'etablissement_nom' => "CLG-VAL D'ARGENT",
        'matiere_enseignee_id' => '003700',
        'matiere_libelle' => 'AIDE ET ACCOMPAGNEMENT TRAVAIL PERSONNEL',
        'classe_id' => 5,
        'etablissement_id' => 1348,
        'prof_principal' => 'N'
      }
    ],
    'telephones' => [ ],
    'groupes_eleves' => [
      {
        'etablissement_code' => '0699990Z',
        'groupe_id' => 609,
        'groupe_libelle' => 'GROUPE 1 BACASABLE',
        'etablissement_nom' => 'ERASME',
        'etablissement_id' => 1
      },
      {
        'etablissement_code' => '0699990Z',
        'groupe_id' => 610,
        'groupe_libelle' => 'GROUPE 2 BACASABLE',
        'etablissement_nom' => 'ERASME',
        'etablissement_id' => 1
      }
    ],
    'groupes_libres' => [ ],
    'parents' => [ ],
    'enfants' => [ ],
    'relations_eleves' => [ ],
    'relations_adultes' => [ ]
  }
}

JSON_CREATE_QUESTION_QCM = {
  id: nil,
  created_at: nil,
  updated_at: nil,
  user_id: 'VAA60000',
  title: 'Quiz numéro 0',
  opt_show_score: 'after_each',
  opt_show_correct: 'after_each',
  opt_can_redo: true,
  opt_can_rewind: true,
  opt_rand_question_order: false,
  opt_shared: false,
  questions: [
    {
      id: nil,
      type: 'qcm',
      libelle: "Création d'une questions de test type qcm",
      media: {
        file: nil,
        type: nil
      },
      hint: {
        libelle: 'Aide de la questions qcm',
        media: {
          file: nil,
          type: nil
        }
      },
      answers: [
        {
          solution: false,
          proposition: 'Proposition 1 qcm',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: true,
          proposition: 'Proposition 2 solution qcm',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: false,
          proposition: '',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: false,
          proposition: '',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: false,
          proposition: '',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: false,
          proposition: '',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: false,
          proposition: '',
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          solution: false,
          proposition: '',
          joindre: {
            file: nil,
            type: nil
          }
        }
      ],
      randanswer: true,
      comment: 'Commentaire de correction à la question qcm',
      leurres: []
    }
  ]
}

JSON_CREATE_QUESTION_TAT = {
  id: nil,
  created_at: nil,
  updated_at: nil,
  user_id: 'VAA60000',
  title: 'Quiz numéro 0',
  opt_show_score: 'after_each',
  opt_show_correct: 'after_each',
  opt_can_redo: true,
  opt_can_rewind: true,
  opt_rand_question_order: false,
  opt_shared: false,
  questions: [
    {
      id: nil,
      type: 'tat',
      libelle: "Création d'une question de test type texte à trous",
      media: {
        file: nil,
        type: nil
      },
      hint: {
        libelle: nil,
        media: {
          file: nil,
          type: nil
        }
      },
      answers: [
        {
          text: 'un test est une procédure de',
          solution: {
            id: nil,
            libelle: 'vérification'
          },
          ponctuation: nil,
          joindre: {
            file: nil,
            type: nil
          }
        },
        {
          text: 'Il permet de verifier les problèmes du logiciel.',
          solution: {
            id: nil,
            libelle: nil
          },
          ponctuation: nil,
          joindre: {
            file: nil,
            type: nil
          }
        }
      ],
      randanswer: true,
      comment: 'Commentaire de correction à la question qcm',
      leurres: [
        {
          id: 'temp_0',
          libelle: 'transformation'
        },
        {
          id: 'temp_1',
          libelle: 'personnalisation'
        }
      ]
    }
  ]
}

JSON_CREATE_QUESTION_ASS = {
  id: nil,
  created_at: nil,
  updated_at: nil,
  user_id: 'VAA60000',
  title: 'Quiz numéro 0',
  opt_show_score: 'after_each',
  opt_show_correct: 'after_each',
  opt_can_redo: true,
  opt_can_rewind: true,
  opt_rand_question_order: false,
  opt_shared: false,
  questions: [
    {
      id: nil,
      type: 'ass',
      libelle: "Création d'une questions de test type association",
      media: {
        file: nil,
        type: nil
      },
      hint: {
        libelle: 'Aide de la questions association',
        media: {
          file: nil,
          type: nil
        }
      },
      answers: [
        {
          leftProposition: {
            libelle: 'Proposition L ASS 1',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          },
          rightProposition: {
            libelle: 'Proposition R ASS 1',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: [
              1
            ]
          }
        },
        {
          leftProposition: {
            libelle: 'Proposition L ASS 2',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: [
              0,
              1
            ]
          },
          rightProposition: {
            libelle: 'Proposition R ASS 2',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: [
              1
            ]
          }
        },
        {
          leftProposition: {
            libelle: 'Proposition L ASS 3',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: [
              2
            ]
          },
          rightProposition: {
            libelle: 'Proposition R ASS 3',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: [
              2
            ]
          }
        },
        {
          leftProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: [

            ]
          },
          rightProposition: {
            libelle: 'Proposition R ASS 4',
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          }
        },
        {
          leftProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          },
          rightProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          }
        },
        {
          leftProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          },
          rightProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          }
        },
        {
          leftProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          },
          rightProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          }
        },
        {
          leftProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          },
          rightProposition: {
            libelle: nil,
            joindre: {
              file: nil,
              type: nil
            },
            solutions: []
          }
        }
      ],
      randanswer: false,
      comment: nil,
      leurres: []
    }
  ]
}
def json_update_question_qcm(quiz, question, suggestions)
  JSON_CREATE_QUESTION_QCM[:id] = quiz.id
  JSON_CREATE_QUESTION_QCM[:updated_at] = quiz.updated_at
  JSON_CREATE_QUESTION_QCM[:created_at] = quiz.created_at
  JSON_CREATE_QUESTION_QCM[:questions][0][:id] = question.id
  JSON_CREATE_QUESTION_QCM[:questions][0][:libelle] = 'libellé de la question mis à jour'
  JSON_CREATE_QUESTION_QCM[:questions][0][:hint][:libelle] = 'aide de la question mise à jour'

  JSON_CREATE_QUESTION_QCM[:questions][0][:answers][0][:id] = suggestions[0].id
  JSON_CREATE_QUESTION_QCM[:questions][0][:answers][0][:proposition] = 'proposition 0 updated'
  JSON_CREATE_QUESTION_QCM[:questions][0][:answers][0][:solution] = false
  JSON_CREATE_QUESTION_QCM[:questions][0][:answers][1][:id] = suggestions[1].id
  JSON_CREATE_QUESTION_QCM[:questions][0][:answers][1][:proposition] = 'proposition 1 updated'
  JSON_CREATE_QUESTION_QCM[:questions][0][:answers][1][:solution] = true
  JSON_CREATE_QUESTION_QCM
end

def json_update_question_tat(quiz, question, suggestions)
  JSON_CREATE_QUESTION_TAT[:id] = quiz.id
  JSON_CREATE_QUESTION_TAT[:updated_at] = quiz.updated_at
  JSON_CREATE_QUESTION_TAT[:created_at] = quiz.created_at
  JSON_CREATE_QUESTION_TAT[:questions][0][:id] = question.id
  JSON_CREATE_QUESTION_TAT[:questions][0][:libelle] = 'libellé de la question mis à jour'
  JSON_CREATE_QUESTION_TAT[:questions][0][:hint][:libelle] = 'aide de la question mise à jour'

  JSON_CREATE_QUESTION_TAT[:questions][0][:answers][0][:id] = suggestions[5].id
  JSON_CREATE_QUESTION_TAT[:questions][0][:answers][0][:text] = 'texte mis à jour'
  JSON_CREATE_QUESTION_TAT[:questions][0][:answers][0][:solution][:id] = suggestions[6].id
  JSON_CREATE_QUESTION_TAT[:questions][0][:answers][0][:solution][:libelle] = 'solution mise à jour'
  JSON_CREATE_QUESTION_TAT[:questions][0][:leurres][0][:id] = 'temp_0'
  JSON_CREATE_QUESTION_TAT[:questions][0][:leurres][0][:libelle] = 'nouveau leurre'
  JSON_CREATE_QUESTION_TAT[:questions][0][:answers].delete_at(1)
  JSON_CREATE_QUESTION_TAT
end

def json_update_question_ass(quiz, question, suggestions)
  JSON_CREATE_QUESTION_ASS[:id] = quiz.id
  JSON_CREATE_QUESTION_ASS[:updated_at] = quiz.updated_at
  JSON_CREATE_QUESTION_ASS[:created_at] = quiz.created_at
  JSON_CREATE_QUESTION_ASS[:questions][0][:id] = question.id
  JSON_CREATE_QUESTION_ASS[:questions][0][:libelle] = 'libellé de la question mis à jour'
  JSON_CREATE_QUESTION_ASS[:questions][0][:hint][:libelle] = 'aide de la question mise à jour'

  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][0][:leftProposition][:id] = suggestions[2].id
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][0][:leftProposition][:libelle] = 'libelle proposition gauche mis à jour'
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][0][:leftProposition][:solutions] = []
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][0][:rightProposition][:id] = suggestions[3].id
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][0][:rightProposition][:libelle] = 'libelle proposition droite mis à jour'
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][0][:rightProposition][:solutions] = [1]
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][1][:leftProposition][:id] = suggestions[4].id
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][1][:leftProposition][:libelle] = 'libelle proposition gauche mis à jour'
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][1][:leftProposition][:solutions] = [0]
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][1][:rightProposition][:libelle] = nil
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][1][:rightProposition][:solutions] = []
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][2][:leftProposition][:libelle] = nil
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][2][:leftProposition][:solutions] = []
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][2][:rightProposition][:libelle] = nil
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][2][:rightProposition][:solutions] = []
  JSON_CREATE_QUESTION_ASS[:questions][0][:answers][3][:rightProposition][:libelle] = nil
  JSON_CREATE_QUESTION_ASS
end

JSON_UPDATE_ORDER_QUESTIONS = {
  id: nil,
  created_at: nil,
  updated_at: nil,
  user_id: 'VAA60000',
  title: 'Quiz numéro 0',
  opt_show_score: 'after_each',
  opt_show_correct: 'after_each',
  opt_can_redo: true,
  opt_can_rewind: true,
  opt_rand_question_order: false,
  opt_shared: false,
  questions: [
    {
      id: nil,
      type: 'TAT',
      libelle: 'Question numéro 2',
      sequence: 0
    },
    {
      id: nil,
      type: 'ASS',
      libelle: 'Question numéro 1',
      sequence: 1
    },
    {
      id: nil,
      type: 'QCM',
      libelle: 'Question numéro 0',
      sequence: 2
    }
  ]
}

JSON_CREATE_ANSWER_QCM = {
  quiz_id: nil,
  session_id: nil,
  question: {
    id: nil,
    type: 'qcm',
    answers: [
      {
        id: nil,
        solution: true
      }
    ]
  }
}

JSON_CREATE_ANSWER_ASS = {
  quiz_id: nil,
  session_id: nil,
  question: {
    id: nil,
    type: 'ass',
    answers: [
      {
        leftProposition: {
          id: nil,
          solutions: []
        },
        rightProposition: {
          id: nil,
          solutions: []
        }
      }
    ]
  }
}

JSON_IMPORTS_QUIZS = [
  {
    user_id: "VAA60001",
    title: "Mon quiz",
    opt_show_score: 'after_each',
    opt_show_correct: 'after_each',
    opt_can_redo: true,
    opt_can_rewind: true,
    opt_rand_question_order: false,
    opt_shared: true,
    questions: [
      {
        type: "QCM",
        question: "Ma question QCM",
        hint: "Petite aide",
        correction_comment: "texte de correction",
        order: 0,
        opt_rand_suggestion_order: false,
        suggestions: [
          {
            text: "première suggestion",
            order: 0,
            position: "L",
            solution: true
          },
          {
            text: "deuxième suggestion",
            order: 1,
            position: "L",
            solution: false
          }
        ]
      },
      {
        type: "TAT",
        question: "Ma question TAT",
        hint: "Petite aide",
        correction_comment: "texte de correction",
        order: 1,
        opt_rand_suggestion_order: false,
        suggestions: [
          {
            left: {
              text: "cette question est une question",
              order: 0,
              position: "L"
            },
            right: {
              text: "TAT",
              order: 0,
              position: "R"
            }
          },
          {
            left: {
              text: "mais attention il peut y avoir des",
              order: 1,
              position: "L",
            },
            right: {
              text: "Leurres",
              order: 1,
              position: "R"
            }
          }
        ],
        leurres: [
          {
            text: "QCM",
            position: "R"
          },
          {
            text: "ASS",
            position: "R"
          }
        ]
      },
      {
        type: "ASS",
        question: "Ma question ASS",
        hint: "Petite aide", 
        correction_comment: "texte de correction",
        order: 2,
        opt_rand_suggestion_order: true,
        suggestions: [
          {
            left: {
              text: "première suggestion gauche",
              order: 0,
              position: "L",
              solutions: [0,1]
            },
            right:{
              text: "première suggestion droite",
              order: 0,
              position: "R",
              solutions: [0,2]
            },
          },
          {
            left: {
              text: "deuxième suggestion gauche",
              order: 1,
              position: "L",
              solutions: []
            },
            right:{
              text: "deuxième suggestion droite",
              order: 1,
              position: "R",
              solutions: [0]
            }
          },
          {
            left: {
              text: "troisième suggestion gauche",
              order: 2,
              position: "L",
              solutions: [0]
            }
          }
        ]
      }
    ] 
  }
]
