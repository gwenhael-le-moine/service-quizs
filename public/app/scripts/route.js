angular.module('quizsApp')
.config(['$stateProvider', '$urlRouterProvider', 'APP_PATH', function($stateProvider, $urlRouterProvider, APP_PATH) {
  $stateProvider
          .state('erreur', {
             url: '/erreur/:code?message',
             templateUrl: APP_PATH + '/app/views/erreur.html',
             controller: 'ErreurCtrl'
            })

          .state( 'quizs',{
            abstract:true,
            templateUrl:APP_PATH + '/app/views/index.html',
          })

          .state( 'quizs.menu',{
            parent: 'quizs',
            abstract:true,
            templateUrl:APP_PATH + '/app/views/menu.html',
          })

          .state( 'quizs.actions',{
            parent: 'quizs',
            abstract:true,
            templateUrl:APP_PATH + '/app/views/actions.html',
          })

          .state( 'quizs.home',{
            parent: 'quizs.menu',
            url: '/',
            views: {
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/main-home.html',
                controller: 'MainHomeCtrl'
               }
              }
            })
          .state( 'quizs.params',{
            parent: 'quizs.actions',
            url: '/params',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'action': {
                templateUrl:APP_PATH + '/app/views/actions/params.html',
                controller: 'ParamsCtrl'
               }
              }
            })
          .state( 'quizs.create_questions',{
            parent: 'quizs.actions',
            url: '/questions',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'action': {
                templateUrl:APP_PATH + '/app/views/actions/create-update-questions.html',
                controller: 'CreateUpdateQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.update_questions',{
            parent: 'quizs.actions',
            url: '/questions/:id',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'action': {
                templateUrl:APP_PATH + '/app/views/actions/create-update-questions.html',
                controller: 'CreateUpdateQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.preview_questions',{
            parent: 'quizs.actions',
            url: '/questions/preview/:id',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'action': {
                templateUrl:APP_PATH + '/app/views/actions/preview-questions.html',
                controller: 'PreviewQuestionsCtrl'
               }
              }
            });

  $urlRouterProvider.otherwise(function ($injector, $location) {
      $location.path("/");
  });
}]);