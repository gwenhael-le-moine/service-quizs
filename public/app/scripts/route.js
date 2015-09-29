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

          .state( 'quizs.back',{
            parent: 'quizs',
            abstract:true,
            templateUrl:APP_PATH + '/app/views/back.html',
          })

          .state( 'quizs.front',{
            parent: 'quizs',
            abstract:true,
            templateUrl:APP_PATH + '/app/views/front.html',
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
            parent: 'quizs.back',
            url: '/:quiz_id/params',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'back': {
                templateUrl:APP_PATH + '/app/views/back/params.html',
                controller: 'ParamsCtrl'
               }
              }
            })
          .state( 'quizs.create_questions',{
            parent: 'quizs.back',
            url: '/:quiz_id/questions',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'back': {
                templateUrl:APP_PATH + '/app/views/back/create-update-questions.html',
                controller: 'CreateUpdateQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.update_questions',{
            parent: 'quizs.back',
            url: '/:quiz_id/questions/:id',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'back': {
                templateUrl:APP_PATH + '/app/views/back/create-update-questions.html',
                controller: 'CreateUpdateQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.preview_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/questions/preview/:id',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/preview-questions.html',
                controller: 'PreviewQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.marking_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/questions/:id/correction',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/marking-questions.html',
                controller: 'MarkingQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.start_quiz',{
            parent: 'quizs.front',
            url: '/:quiz_id/start',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/start-quiz.html',
                controller: 'StartQuizCtrl'
               }
              }
            });

  $urlRouterProvider.otherwise(function ($injector, $location) {
      $location.path("/");
  });
}]);