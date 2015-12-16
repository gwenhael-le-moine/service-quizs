'use strict';

/* Services */
angular.module('quizsApp')
.factory('QuestionsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/questions/', {}, {
  	'get': {method: 'GET', url: APP_PATH + '/api/questions/:id', params: {id: '@id', marking: '@marking', session_id: '@session_id'}},
    'create': {method: 'POST', url: APP_PATH + '/api/questions/create', params: {quiz: '@quiz'}},
    'getAll': {method: 'GET', url: APP_PATH + '/api/questions/all/:quiz_id', params: {quiz_id: '@quiz_id', read: '@read', marking: '@marking', session_id: '@session_id'}},
    'update': {method: 'PUT', url: APP_PATH + '/api/questions/update', params: {quiz: '@quiz'}},
    'updateOrder': {method: 'PUT', url: APP_PATH + '/api/questions/update/order', params: {quiz: '@quiz'}},
    'delete': {method: 'DELETE', url: APP_PATH + '/api/questions/:id', params: {id: '@id'}}
  });
}])
.service('Questions', [ '$rootScope', 'QuestionsApi', function( $rootScope, QuestionsApi) {
  this.get = function(quiz_id, id, marking, session_id){
    if (id) {
      return QuestionsApi.get({id: id, marking: marking, session_id: session_id});
    } else {
      return QuestionsApi.getAll({quiz_id: quiz_id, marking: marking, session_id: session_id});
    };
  }
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