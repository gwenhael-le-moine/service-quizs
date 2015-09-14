'use strict';

// Declare app level module which depends on filters, and services
angular.module('quizsApp', [
  'ui.router', 
  'ngResource', 
  'ui.bootstrap',
  'ui.sortable',
  'as.sortable',
  'angular-carousel',
  'ngColorPicker',
  'ngFileUpload',
  'services.messages',
  'growlNotifications',
]).run(['$rootScope', '$location', 'Notifications', function($rootScope, $location, Notifications) {
  Notifications.clear();
  //initialisation des données
  // les suggestions
  $rootScope.tmpId = 0;
  $rootScope.quiz = {
    title: "Insérez un titre pour votre quiz",
    opts:{},
    questions: []
  }
   $rootScope.tmpQuiz = {
      title: "",
      opts:{},
      questions: [{
      id: 0,
      type: "qcm",
      libelle: "De quels sons s'inspire le compositeur J. Brahms dans sa première composition ?",
      media: {file: "null", type:"audio"},
      hint: {libelle:"Tu dois trouver deux sons différents.", media: {file: "null", type:"audio"}},
      answers:[
        {solution: false, proposition: "Le chant d'une baleine", joindre: {file: "null", type: "image"}},
        {solution: false, proposition: "Le chant d'un moineau", joindre: {file: null, type: null}},
        {solution: false, proposition: "Le chant d'un loup", joindre: {file: "null", type: "son"}},
        {solution: false, proposition: "Le chant d'un dauphin", joindre: {file: null, type: null}},
        {solution: false, proposition: "Le chant d'une mouette", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}},
        {solution: false, proposition: "", joindre: {file: null, type: null}}
      ],
      randanswer: false,
      comment: null
    }]
  }
  
  $rootScope.$on('$stateChangeStart', function($location){
    // console.log("good");
    Notifications.clear();
  });
  window.scope = $rootScope;
}]);