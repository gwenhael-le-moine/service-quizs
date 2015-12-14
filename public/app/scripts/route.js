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
            resolve: {
              Users : 'Users',
              currentUser: function(Users){
                Users.getCurrentUserRequest().$promise.then(function(response){
                  console.log(response);
                  Users.setCurrentUser(response);
                  return true;
                });
              }
            },
            templateUrl:APP_PATH + '/app/views/index.html',
          })

          .state( 'quizs.menu',{
            parent: 'quizs',
            abstract:true,
            templateUrl:APP_PATH + '/app/views/menu.html',
          })

          .state( 'quizs.damier',{
            parent: 'quizs',
            abstract:true,
            templateUrl:APP_PATH + '/app/views/damier.html',
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
          .state( 'quizs.publish',{
            parent: 'quizs.damier',
            url: '/:quiz_id/publish',
            views: {
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-publish.html',
                controller: 'AsidePublishCtrl'
              },
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/main-publish.html',
                controller: 'MainPublishCtrl'
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
          .state( 'quizs.preview_create_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/questions/preview/',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/questions.html',
                controller: 'PreviewQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.preview_update_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/questions/:id/preview',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/questions.html',
                controller: 'PreviewQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.marking_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/questions/:id/correction',
            params: {
              session_id: null,
              next_question_id: null
            },
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
            })
          .state( 'quizs.read_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/start/questions/:id',
            params: {
              session_id: null
            },
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/questions.html',
                controller: 'ReadQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.sessions',{
            parent: 'quizs.front',
            url: '/:quiz_id/sessions',
            params: {
              student_id: null,
              rgpt_id: null
            },
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/sessions.html',
                controller: 'SessionsCtrl'
               }
              }
            });

  $urlRouterProvider.otherwise(function ($injector, $location) {
      $location.path("/");
  });
}]);