'use strict';

/* Services */
angular.module('quizsApp')
// .factory('QuizsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
//   return $resource( APP_PATH + '/api/quizs/', {});
// }])
.service('Quizs', [ '$rootScope', function( $rootScope) {
  //transforme la question pour la preview
  this.sanitizePreviewQuestion = function(){
    if ($rootScope.previewQuestion.type === 'qcm') {
      for (var i = $rootScope.previewQuestion.answers.length - 1; i >= 0; i--) {
        $rootScope.previewQuestion.answers[i].solution = false;
      };
    };
    if ($rootScope.previewQuestion.type === 'ass') {
      for (var i = $rootScope.previewQuestion.answers.length - 1; i >= 0; i--) {
        $rootScope.previewQuestion.answers[i].leftProposition.solutions = [];
        $rootScope.previewQuestion.answers[i].rightProposition.solutions = [];
      };
    };
    if ($rootScope.previewQuestion.type === 'tat') {
      for (var i = $rootScope.previewQuestion.answers.length - 1; i >= 0; i--) {
        $rootScope.previewQuestion.answers[i].currentSelectSolution = "--------";
      };
    };
    return $rootScope.previewQuestion;
  };
  //retourne les solutions pour le tat
  this.getPreviewSolutionTAT = function(){
    var previewSolutionTAT = [];
    if ($rootScope.previewQuestion.type === 'tat') {
      //on récupère les leurres
      previewSolutionTAT = $rootScope.previewQuestion.leurres;
      //on récupère les réponses
      for (var i = $rootScope.previewQuestion.answers.length - 1; i >= 0; i--) {
        previewSolutionTAT.push($rootScope.previewQuestion.answers[i].solution);
      };
    };
    return _.shuffle(previewSolutionTAT);
  };
  // Variables vide lorsque l'on veut remettre à zéro
  this.getDefaultQuestion = function(){
    return {
      id: null,
      type: "qcm",
      libelle: null,
      media: {file: null, type: null},
      hint: {libelle:null, media: {file: null, type: null}},
      answers:[],
      randanswer: false,
      comment: null
    };
  };
  this.getDefaultSuggestions =  function(){
    return {
      qcm: [
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}}
      ],
      ass: [
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        },
        {
          leftProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}, 
          rightProposition: {libelle: null, joindre: {file: null, type: null}, solutions: []}
        }
      ],
      tat: [
        {
          text: null,
          solution: {id: null, libelle: null},
          ponctuation: null,
          joindre: {file: null, type: null}
        }
      ],
      leurres: [
      ]
    };
  };
}]);