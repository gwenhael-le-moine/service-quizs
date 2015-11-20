'use strict';

/* Services */
angular.module('quizsApp')
.factory('QuizsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/quizs/', {}, {
    'get': {method: 'GET', url: APP_PATH + '/api/quizs/:id', params: {id: '@id'}},
    'create': {method: 'GET', url: APP_PATH + '/api/quizs/create'},
    'update': {method: 'POST', url: APP_PATH + '/api/quizs/update/:id', params: {id: '@id', opt_show_score: '@opt_show_score', opt_show_correct: '@opt_show_correct', title: '@title', opt_can_redo:'@opt_can_redo', opt_can_rewind: '@opt_can_rewind', opt_rand_question_order: '@opt_rand_question_order', opt_shared:'@opt_shared'}}
  });
}])
.service('Quizs', [ '$rootScope', function( $rootScope) {
  var self = this;
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
  this.getFormatOpt = function(quiz){
    var opts = {
      randQuestion: {yes: false, no: true},
      modes: {training: true, exercise: false, assessment: false, perso: false},
      correction: {afterEach: true, atEnd: false, none: false},
      canRewind: {yes: true, no: false},
      score: {afterEach: true, atEnd: false, none: false},
      canRedo: {yes: true, no: false}
    };
    if (quiz.opt_rand_question_order) opts.randQuestion = {yes: true, no: false};
    if (!quiz.opt_can_rewind) opts.canRewind = {yes: false, no: true};
    if (!quiz.opt_can_redo) opts.canRedo = {yes: false, no: true};
    opts.score = self.getEnumOpts(quiz.opt_show_score);
    opts.correction = self.getEnumOpts(quiz.opt_show_correct);
    opts.modes = self.getOptsMode(quiz);
    return opts;
  };
  // retourne dans le bon format des options de l'ihm paramètres,
  // les enums show_correction et score
  this.getEnumOpts = function(optQuiz){
    var enumFormat = {afterEach: false, atEnd: false, none: true};
    switch(optQuiz){
      case "after_each":
        enumFormat = {afterEach: true, atEnd: false, none: false};
        break;
      case "at_end":
        enumFormat = {afterEach: false, atEnd: true, none: false};
        break;
    };
    return enumFormat;
  };
  this.getOptsMode = function(quiz){
    var modeFormat = {training: false, exercise: false, assessment: false, perso: true};
    if (quiz.opt_show_score == 'after_each' && quiz.opt_show_correct == 'after_each' && quiz.opt_can_rewind && quiz.opt_can_redo) {
      modeFormat = {training: true, exercise: false, assessment: false, perso: false};
    };
    if (quiz.opt_show_score == 'at_end' && quiz.opt_show_correct == 'at_end' && !quiz.opt_can_rewind && !quiz.opt_can_redo) {
      modeFormat = {training: false, exercise: true, assessment: false, perso: false};
    };
    if (quiz.opt_show_score == 'none' && quiz.opt_show_correct == 'none' && !quiz.opt_can_rewind && !quiz.opt_can_redo) {
      modeFormat = {training: false, exercise: false, assessment: true, perso: false};
    };
    return modeFormat;
  };
  this.updateOpt = function(quiz, opt, buttonChanged){
    var params = {id: quiz.id, opt_show_correct: null, opt_show_score: null, opt_can_redo: null, opt_can_rewind: null, opt_rand_question_order: null};
    switch(opt){
      case "modes":
        if (buttonChanged == 'training') {
          params.opt_show_correct = 'after_each';
          params.opt_show_score = 'after_each';
          params.opt_can_rewind = true;
          params.opt_can_redo = true;
        } else if (buttonChanged == 'exercise') {
          params.opt_show_correct = 'at_end';
          params.opt_show_score = 'at_end';
          params.opt_can_rewind = false;
          params.opt_can_redo = false;
        } else {
          params.opt_show_correct = 'none';
          params.opt_show_score = 'none';
          params.opt_can_rewind = false;
          params.opt_can_redo = false;
        };
        break;
      case "correction":
        if (buttonChanged == 'afterEach') {
          params.opt_show_correct = 'after_each';
        } else if (buttonChanged == 'atEnd') {
          params.opt_show_correct = 'at_end';
        } else {
          params.opt_show_correct = 'none';
        };
        break;
      case "score":
        if (buttonChanged == 'afterEach') {
          params.opt_show_score = 'after_each';
        } else if (buttonChanged == 'atEnd') {
          params.opt_show_score = 'at_end';
        } else {
          params.opt_show_score = 'none';
        };
        break;
      case "canRewind":
        if (buttonChanged == 'yes') {
          params.opt_can_rewind = true;
        } else {
          params.opt_can_rewind = false;
        };
        break;
      case "canRedo":
        if (buttonChanged == 'yes') {
          params.opt_can_redo = true;
        } else {
          params.opt_can_redo = false;
        };
        break;  
      case "randQuestion":
        if (buttonChanged == 'yes') {
          params.opt_rand_question_order = true;
        } else {
          params.opt_rand_question_order = false;
        };
        break;
    };
    return params;
  };
  this.changeOptsAdvanced = function(buttonChanged) {
    var opts = {
      randQuestion: {yes: false, no: true},
      modes: {training: true, exercise: false, assessment: false, perso: false},
      correction: {afterEach: true, atEnd: false, none: false},
      canRewind: {yes: true, no: false},
      score: {afterEach: true, atEnd: false, none: false},
      canRedo: {yes: true, no: false}
    };
    switch(buttonChanged){
      case "exercise":
        opts.modes.training = false;
        opts.modes.exercise = true;
        opts.correction.afterEach = false;
        opts.correction.atEnd = true;
        opts.canRewind.yes = false;
        opts.canRewind.no = true;
        opts.score.afterEach = false;
        opts.score.atEnd = true;
        opts.canRedo.yes = false;
        opts.canRedo.no = true;
        break;
      case "assessment":
        opts.modes.training = false;
        opts.modes.assessment = true;
        opts.correction.afterEach = false;
        opts.correction.none = true;
        opts.canRewind.yes = false;
        opts.canRewind.no = true;
        opts.score.afterEach = false;
        opts.score.none = true;
        opts.canRedo.yes = false;
        opts.canRedo.no = true;
        break;
    }
    return opts;
  };
  this.randQuestions = function(questions){
    questions = _.shuffle(questions);
    for (var i = questions.length - 1; i >= 0; i--) {
      questions[i].sequence = i;
    };
    return questions;
  };
}]);