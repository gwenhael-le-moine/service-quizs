'use strict';

// Declare app level module which depends on filters, and services
angular.module('quizsApp', [
  'ui.router', 
  'ngResource', 
  'ui.bootstrap',
  'ui.sortable',
  'as.sortable',
  'ngFileUpload',
  'services.messages',
  'growlNotifications',
]).run(['$rootScope', '$location', 'Notifications', function($rootScope, $location, Notifications) {
  Notifications.clear();
  //initialisation des données
  //id temp à effacer pour la BO
  $rootScope.tmpId = 0;

  //récupration d'un quiz 
  $rootScope.quiz = {
    id : 0,
    title: "Le compositeur J. Brahms",
    opts:{
      randQuestion: {yes: false, no: true},
      modes: {training: true, exercise: false, assessment: false, perso: false},
      correction: {afterEach: true, atEnd: false, none: false},
      canRewind: {yes: true, no: false},
      score: {afterEach: true, atEnd: false, none: false},
      canRedo: {yes: true, no: false}
    },
    score: "00",
    questions: [
      {
        id: 10,
        type : 'qcm',
        libelle: "De quels sons s'inspire le compositeur J. Brahms dans sa première composition ?",
        media: {file: {url: "url du fichier", name: "composition_brahms.mp3"}, type: 'audio'},
        hint:{libelle: "Tu dois trouver deux sons différents.", media:{file: null, type: null}},
        answers: [
          {
            id:0, solution: true, proposition: "Le chant d'une baleine", joindre: {file: {url: "url du fichier", name: "chant_baleine.mp3"}, type: "audio"}
          },
          {
            id:1, solution: true, proposition: "Le chant d'un moineau", joindre: {file: null, type: null}
          },
          {
            id:2, solution: false, proposition: "Le chant d'un loup", joindre: {file: null, type: null}
          },
          {
            id:3, solution: false, proposition: "Le chant d'un dauphin", joindre: {file: null, type: null}          
          },
          {
            id:4, solution: false, proposition: "Le chant d'une mouette", joindre: {file: null, type: null}
          },
          {
            id:null, solution: false, proposition: null, joindre: {file: null, type: null}
          },
          {
            id:null, solution: false, proposition: null, joindre: {file: null, type: null}
          },
          {
            id:null, solution: false, proposition: null, joindre: {file: null, type: null}
          }                    
        ],
        randanswer: false,
        comment: null,
        sequence: 0
      },
      {
        id: 11,
        type : 'ass',
        libelle: "Retrouve les familles d'instruments qui correspondent à chacun des instruments utilisés par le compositeur.",
        media: {file: null, type: null},
        hint:{libelle: null, media:{file: null, type: null}},
        answers: [
          {
            leftProposition: {id: 5, libelle: "La flûte traversière", joindre: {file: null, type: null}, solutions: [2]}, 
            rightProposition: {id: 6, libelle: "Cordes pincées", joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: 7, libelle: "Le hautbois", joindre: {file: {url: "url du fichier", name: "hautbois.jpg"}, type: "image"}, solutions: [2]}, 
            rightProposition: {id: 8, libelle: "Cordes frottées", joindre: {file: null, type: null}, solutions: [2]}
          },
          {
            leftProposition: {id: 9, libelle: "Le violon alto", joindre: {file: {url: "url du fichier", name: "violon_alto.png"}, type: "image"}, solutions: [1]}, 
            rightProposition: {id: 10, libelle: "Instruments à vent", joindre: {file: {url: "url du fichier", name: "flute.mp3"}, type: "audio"}, solutions: [0,1]}
          },
          {
            leftProposition: {id: 11, libelle: "Le piano", joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: 12, libelle: "Percussion", joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: null, libelle: null, joindre: {file: null, type: null}, solutions: []}
          }
        ],
        randanswer: false,
        comment: null,
        sequence: 1
      },
      {
        id: 12,
        type : 'tat',
        libelle: "Complète ce texte à propos du compositeur J. Brahms.",
        media: {file: null, type: null},
        hint:{libelle: null, media:{file: null, type: null}},
        answers: [
          {
            id: 13,
            text: "J. Brahms est un compositeur",
            solution: {id: 31, libelle:"allemand"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 15,
            text: "Son prénom est",
            solution: {id: 32, libelle:"Johannes"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 17,
            text: "Très jeune, il apprend à jouer",
            solution: {id: 18, libelle:"du piano"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 19,
            text: "Adulte, il écrit des partitions pour",
            solution: {id: 33, libelle:"tous les instruments"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 21,
            text: "Il appartient au même mouvement musical que",
            solution: {id: 34, libelle:"L. V. Beethoven"},
            ponctuation: ",",
            joindre: {file: {name: "musique_beethoven.mp3", url: "url du fichier"}, type: "audio"}
          },
          {
            id: 23,
            text: "ou encore",
            solution: {id: 20, libelle:"J. S. Bach"},
            ponctuation: ".",
            joindre: {file: {name: "musique_bach.mp3", url: "url du fichier"}, type: "audio"}
          },
          {
            id: 25,
            text: "Son style musical est très différent de",
            solution: {id: 22, libelle:"A. Vivaldi"},
            ponctuation: ",",
            joindre: {file: {name: "musique_vivaldi.mp3", url: "url du fichier"}, type: "audio"}
          },
          {
            id: 27,
            text: "compositeur",
            solution: {id: 35, libelle:"italien"},
            ponctuation: ",",
            joindre: {file: null, type: null}
          },
          {
            id: 29,
            text: "qui est, lui, un virtuose",
            solution: {id: 30, libelle:"du violon"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          }
        ],
        leurres: [
          {
            id: 56,
            libelle:"autrichien"
          },
          {
            id: 57,
            libelle:"Johans"
          },
          {
            id: 58,
            libelle:"du hautbois"
          },
          {
            id: 59,
            libelle:"du clavecin"
          }
        ],
        randanswer: false,
        comment: null,
        sequence: 2
      }       
    ]
  }

  //initialisation d'un quiz avec les réponses de l'élèves
  $rootScope.quizStudent = {
    id : 0,
    title: "Le compositeur J. Brahms",
    opts:{
      randQuestion: {yes: false, no: true},
      modes: {training: true, exercise: false, assessment: false, perso: false},
      correction: {afterEach: true, atEnd: false, none: false},
      canRewind: {yes: true, no: false},
      score: {afterEach: true, atEnd: false, none: false},
      canRedo: {yes: true, no: false}
    },
    score: "08",
    questions: [
      {
        id: 10,
        type : 'qcm',
        libelle: "De quels sons s'inspire le compositeur J. Brahms dans sa première composition ?",
        media: {file: {url: "url du fichier", name: "composition_brahms.mp3"}, type: 'audio'},
        hint:{libelle: "Tu dois trouver deux sons différents.", media:{file: null, type: null}},
        answers: [
          {
            id:0, solution: false, proposition: "Le chant d'une baleine", joindre: {file: {url: "url du fichier", name: "chant_baleine.mp3"}, type: "audio"}
          },
          {
            id:1, solution: true, proposition: "Le chant d'un moineau", joindre: {file: null, type: null}
          },
          {
            id:2, solution: true, proposition: "Le chant d'un loup", joindre: {file: null, type: null}
          },
          {
            id:3, solution: false, proposition: "Le chant d'un dauphin", joindre: {file: null, type: null}          
          },
          {
            id:4, solution: false, proposition: "Le chant d'une mouette", joindre: {file: null, type: null}
          }                    
        ],
        randanswer: false,
        comment: null,
        sequence: 0
      },
      {
        id: 11,
        type : 'ass',
        libelle: "Retrouve les familles d'instruments qui correspondent à chacun des instruments utilisés par le compositeur.",
        media: {file: null, type: null},
        hint:{libelle: null, media:{file: null, type: null}},
        answers: [
          {
            leftProposition: {id: 5, libelle: "La flûte traversière", joindre: {file: null, type: null}, solutions: [10]}, 
            rightProposition: {id: 6, libelle: "Cordes pincées", joindre: {file: null, type: null}, solutions: [9]}
          },
          {
            leftProposition: {id: 7, libelle: "Le hautbois", joindre: {file: {url: "url du fichier", name: "hautbois.jpg"}, type: "image"}, solutions: []}, 
            rightProposition: {id: 8, libelle: "Cordes frottées", joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: 9, libelle: "Le violon alto", joindre: {file: {url: "url du fichier", name: "violon_alto.png"}, type: "image"}, solutions: [6]}, 
            rightProposition: {id: 10, libelle: "Instruments à vent", joindre: {file: {url: "url du fichier", name: "flute.mp3"}, type: "audio"}, solutions: [5]}
          },
          {
            leftProposition: {id: 11, libelle: "Le piano", joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: 12, libelle: "Percussion", joindre: {file: null, type: null}, solutions: []}
          }
        ],
        randanswer: false,
        comment: null,
        sequence: 1
      },
      {
        id: 12,
        type : 'tat',
        libelle: "Complète ce texte à propos du compositeur J. Brahms.",
        media: {file: null, type: null},
        hint:{libelle: null, media:{file: null, type: null}},
        answers: [
          {
            id: 13,
            text: "J. Brahms est un compositeur",
            solution: {id: 14, libelle: "autrichien"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 15,
            text: "Son prénom est",
            solution: {id: 16, libelle: "Johann"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 17,
            text: "Très jeune, il apprend à jouer",
            solution: {id: 18, libelle: "du piano"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 19,
            text: "Adulte, il écrit des partitions pour",
            solution: {id: 20, libelle: "J. S. Bach"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 21,
            text: "Il appartient au même mouvement musical que",
            solution: {id: 22, libelle: "A. Vivaldi"},
            ponctuation: ",",
            joindre: {file: {url: "url du fichier", name: "musique_bach.mp3"}, type: "audio"}
          },
          {
            id: 23,
            text: "ou encore",
            solution: null,
            ponctuation: ".",
            joindre: {file: {url: "url du fichier", name: "musique_beethoven.mp3"}, type: "audio"}
          },
          {
            id: 25,
            text: "Son style musical est très différent de",
            solution: null,
            ponctuation: ",",
            joindre: {file: {url: "url du fichier", name: "musique_vivaldi.mp3"}, type: "audio"}
          },
          {
            id: 27,
            text: "compositeur",
            solution: {id: 28, libelle: "français"},
            ponctuation: ",",
            joindre: {file: null, type: null}
          },
          {
            id: 29,
            text: "qui est, lui, un virtuose",
            solution: {id: 30, libelle: "du violon"},
            ponctuation: ".",
            joindre: {file: null, type: null}
          }
        ],
        randanswer: false,
        comment: null,
        sequence: 2
      }       
    ]
  }
  //solutions juste pour la dynamic ihm
  $rootScope.quizSolution = {
    id: 0,
    questions: [
      {
        id: 10,
        solutions: [0, 1]
      },
      {
        id: 11,
        solutions: [
          {
            id: 5,
            solutions: [10]
          },
          {
            id: 7,
            solutions: [10]
          },
          {
            id: 9,
            solutions: [8]
          }
        ]
      },
      {
        id: 12,
        solutions: [
          {
            id: 13,
            solution: {id: 31, libelle:"allemand"}
          },
          {
            id: 15,
            solution: {id: 32, libelle:"Johannes"}
          },
          {
            id: 17,
            solution: {id: 18, libelle:"du piano"}
          },
          {
            id: 19,
            solution: {id: 33, libelle:"tous les instruments"}
          },
          {
            id: 21,
            solution: {id: 34, libelle:"L. V. Beethoven"}
          },
          {
            id: 23,
            solution: {id: 20, libelle:"J. S. Bach"}
          },
          {
            id: 25,
            solution: {id: 22, libelle:"A. Vivaldi"}
          },
          {
            id: 27,
            solution: {id: 35, libelle:"italien"}
          },
          {
            id: 29,
            solution: {id: 30, libelle:"du violon"}
          }
        ]
      }
    ]
  }

  //récupration d'un quiz 
  $rootScope.quizStart = {
    id : 0,
    title: "",
    opts:{
      randQuestion: {yes: false, no: true},
      modes: {training: true, exercise: false, assessment: false, perso: false},
      correction: {afterEach: true, atEnd: false, none: false},
      canRewind: {yes: false, no: true},
      score: {afterEach: true, atEnd: false, none: false},
      canRedo: {yes: true, no: false}
    },
    score: "00",
    questions: [
      {
        id: 10,
        type : 'qcm',
        libelle: "De quels sons s'inspire le compositeur J. Brahms dans sa première composition ?",
        media: {file: {url: "url du fichier", name: "composition_brahms.mp3"}, type: 'audio'},
        hint:{libelle: "Tu dois trouver deux sons différents.", media:{file: null, type: null}},
        answers: [
          {
            id:0, solution: false, proposition: "Le chant d'une baleine", joindre: {file: {url: "url du fichier", name: "chant_baleine.mp3"}, type: "audio"}
          },
          {
            id:1, solution: false, proposition: "Le chant d'un moineau", joindre: {file: null, type: null}
          },
          {
            id:2, solution: false, proposition: "Le chant d'un loup", joindre: {file: null, type: null}
          },
          {
            id:3, solution: false, proposition: "Le chant d'un dauphin", joindre: {file: null, type: null}          
          },
          {
            id:4, solution: false, proposition: "Le chant d'une mouette", joindre: {file: null, type: null}
          }                    
        ],
        randanswer: false,
        comment: null,
        sequence: 0
      },
      {
        id: 11,
        type : 'ass',
        libelle: "Retrouve les familles d'instruments qui correspondent à chacun des instruments utilisés par le compositeur.",
        media: {file: null, type: null},
        hint:{libelle: null, media:{file: null, type: null}},
        answers: [
          {
            leftProposition: {id: 5, libelle: "La flûte traversière", joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: 6, libelle: "Cordes pincées", joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: 7, libelle: "Le hautbois", joindre: {file: {url: "url du fichier", name: "hautbois.jpg"}, type: "image"}, solutions: []}, 
            rightProposition: {id: 8, libelle: "Cordes frottées", joindre: {file: null, type: null}, solutions: []}
          },
          {
            leftProposition: {id: 9, libelle: "Le violon alto", joindre: {file: {url: "url du fichier", name: "violon_alto.png"}, type: "image"}, solutions: []}, 
            rightProposition: {id: 10, libelle: "Instruments à vent", joindre: {file: {url: "url du fichier", name: "flute.mp3"}, type: "audio"}, solutions: []}
          },
          {
            leftProposition: {id: 11, libelle: "Le piano", joindre: {file: null, type: null}, solutions: []}, 
            rightProposition: {id: 12, libelle: "Percussion", joindre: {file: null, type: null}, solutions: []}
          }
        ],
        randanswer: false,
        comment: null,
        sequence: 1
      },
      {
        id: 12,
        type : 'tat',
        libelle: "Complète ce texte à propos du compositeur J. Brahms.",
        media: {file: null, type: null},
        hint:{libelle: null, media:{file: null, type: null}},
        answers: [
          {
            id: 13,
            text: "J. Brahms est un compositeur",
            solution: null,
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 15,
            text: "Son prénom est",
            solution: null,
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 17,
            text: "Très jeune, il apprend à jouer",
            solution: null,
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 19,
            text: "Adulte, il écrit des partitions pour",
            solution: null,
            ponctuation: ".",
            joindre: {file: null, type: null}
          },
          {
            id: 21,
            text: "Il appartient au même mouvement musical que",
            solution: null,
            ponctuation: ",",
            joindre: {file: "url file", type: "audio"}
          },
          {
            id: 23,
            text: "ou encore",
            solution: null,
            ponctuation: ".",
            joindre: {file: "url file", type: "audio"}
          },
          {
            id: 25,
            text: "Son style musical est très différent de",
            solution: null,
            ponctuation: ",",
            joindre: {file: "url file", type: "audio"}
          },
          {
            id: 27,
            text: "compositeur",
            solution: null,
            ponctuation: ",",
            joindre: {file: null, type: null}
          },
          {
            id: 29,
            text: "qui est, lui, un virtuose",
            solution: null,
            ponctuation: ".",
            joindre: {file: null, type: null}
          }
        ],
        solutions: [
          {
            id: 31, 
            libelle:"allemand"
          },
          {
            id: 32, 
            libelle:"Johannes"
          },
          {
            id: 18, 
            libelle:"du piano"
          },
          {
            id: 33, 
            libelle:"tous les instruments"
          },
          {
           id: 34, 
           libelle:"L. V. Beethoven"
          },
          {
            id: 20, 
            libelle:"J. S. Bach"
          },
          {
            id: 22, 
            libelle:"A. Vivaldi"
          },
          {
            id: 35, 
            libelle:"italien"
          },
          {
            id: 30, 
            libelle:"du violon"
          },
          {
            id: 56,
            libelle:"autrichien"
          },
          {
            id: 57,
            libelle:"Johans"
          },
          {
            id: 58,
            libelle:"du hautbois"
          },
          {
            id: 59,
            libelle:"du clavecin"
          }
        ],
        randanswer: false,
        comment: null,
        sequence: 2
      }       
    ]
  }
  //pour les parents on récupère leurs enfants
  $rootScope.childs = [
    {
      id:0,
      name: "ambre mailet",
      quizs:[0,2]
    },
    {
      id:1,
      name: "thomas mailet",
      quizs:[1]
    }
  ];

  //liste des quiz d'un prof
  $rootScope.quizs = [
    {
      id: 0,
      title: "Le compositeur J. Brahms",
      nbQuestion: 3,
      canRedo: false,
      publishes: [],
      //pour les élèves et les parents
      session: {id:0, score: "16"},
      share: false
    },
    {
      id: 1,
      title: "la géométrie dans l'espace",
      nbQuestion: 10,
      canRedo: true,
      publishes: [
        {
          id: 0,
          name: "6 eme a"
        },
        {
          id: 1,
          name: "5 EME C"
        },
        {
          id: 2,
          name: "5 EME D"
        }
      ],
      share: true
    },
    {
      id: 2,
      title: "La seconde guerre mondial de 39/45",
      nbQuestion: 25,
      canRedo: true,
      publishes: [
        {
          id: 3,
          name: "6EME 1 BACASABLE"
        },
        {
          id: 4,
          name: "6EME 2 BACASABLE"
        },
      ],
      //pour les élèves et les parents
      session: {id:1, score: "08"},
      share: true
    }
  ];

  $rootScope.lastSessions = [
    {
      id: 0,
      quiz: {
        id: 0,
        title: "Le compositeur J. Brahms"
      },
      nameElv: "ambre mailet",
      date: "08/10/15"
    },
    {
      id: 1,
      quiz: {
        id: 0,
        title: "Le compositeur J. Brahms"
      },
      nameElv: "thomas lemaitre",
      date: "07/10/15"
    },
    {
      id: 2,
      quiz: {
        id: 0,
        title: "Le compositeur J. Brahms"
      },
      nameElv: "fred roy",
      date: "07/10/15"
    },
    {
      id: 3,
      quiz: {
        id: 2,
        title: "La seconde guerre mondial de 39/45"
      },
      nameElv: "allan parich",
      date: "05/10/15"
    },
    {
      id: 4,
      quiz: {
        id: 2,
        title: "La seconde guerre mondial de 39/45"
      },
      nameElv: "piggy groingroin",
      date: "05/10/15"
    }
  ];
  $rootScope.lastQuizsShare = [
    {
      id: 1,
      title: "la géométrie dans l'espace",
      nbQuestion: 10,
      date: "09/10/15"
    },
    {
      id: 2,
      title: "La seconde guerre mondial de 39/45",
      nbQuestion: 25,
      date: "05/10/15"
    }
  ];
  
  $rootScope.$on('$stateChangeStart', function($location){
    // console.log("good");
    Notifications.clear();
  });
  window.scope = $rootScope;
}]);