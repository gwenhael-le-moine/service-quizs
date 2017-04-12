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
              currentUser: function(Users){
                return Users.getCurrentUserRequest().$promise.then(function(response){
                  Users.setCurrentUser(response);
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
            parent: 'quizs.menu',
            url: '/:quiz_id/publish',
            views: {    
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },     
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/main-publish.html',
                controller: 'AsidePublishCtrl'
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
            url: '/:quiz_id/questions/preview',
            views: {         
              'quiz': {
                templateUrl:APP_PATH + '/app/views/mains/quiz.html',
                controller: 'QuizCtrl'
              },
              'front': {
                templateUrl:APP_PATH + '/app/views/front/questionsPrev.html',
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
                templateUrl:APP_PATH + '/app/views/front/questionsPrev.html',
                controller: 'PreviewQuestionsCtrl'
               }
              }
            })
          .state( 'quizs.marking_questions',{
            parent: 'quizs.front',
            url: '/:quiz_id/questions/correction/',
            params: {
              id: null,
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
            url: '/:quiz_id/:publication_id/start',
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
           .state( 'quizs.bibliotheque',{
            parent: 'quizs.menu',
            url: '/bibliotheque',
            params: {
            },
            views: {    
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },     
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/main-bibliotheque.html',
                controller: 'AsideHomeCtrl'
               }
              }
            })
           .state( 'quizs.publicationencours',{
            parent: 'quizs.menu',
            url: '/publication-en-cours',
            params: {
            },
            views: {    
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },     
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/main-publication-en-cours.html',
                controller: 'MainHomeCtrl'
               }
              }
            })
          .state( 'quizs.all-sessions',{
            parent: 'quizs.menu',
            url: '/:quiz_id/all-sessions',
            params: {
              student_id: null,
              rgpt_id: null
            },
            views: {    
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },     
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/all-sessions.html',
                controller: 'SessionsCtrl'
               }
              }
            })
          .state( 'quizs.sessions-pub',{
            parent: 'quizs.menu',
            url: '/:quiz_id/all-sessions-pub',
            params: {
              student_id: null,
              rgpt_id: null
            },
            views: {    
              'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },     
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/main-sessions-pub.html',
                controller: 'SessionsCtrl'
               }
              }
            })
          .state( 'quizs.sessions',{
            parent: 'quizs.menu',
            url: '/:quiz_id/sessions',
            params: {
              student_id: null,
              rgpt_id: null
            },
            views: {         
                'aside': {
                templateUrl:APP_PATH + '/app/views/asides/aside-home.html',
                controller: 'AsideHomeCtrl'
              },  
              'main': {
                templateUrl:APP_PATH + '/app/views/mains/sessions.html',
                controller: 'SessionsCtrl'
               }
              }
});

  $urlRouterProvider.otherwise(function ($injector, $location) {
      $location.path("/");
  });
}]);