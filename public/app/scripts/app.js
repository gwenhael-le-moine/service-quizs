'use strict';

// Declare app level module which depends on filters, and services
angular.module('quizsApp', [
  'ui.router', 
  'ngResource', 
  'ui.bootstrap',
  'ui.sortable',
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
  
  $rootScope.$on('$stateChangeStart', function($location){
    // console.log("good");
    Notifications.clear();
  });
  window.scope = $rootScope;
}]);