'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('ParamsCtrl', ['$scope', '$state', '$rootScope', 'Notifications', function($scope, $state, $rootScope, Notifications) {
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'paramètres';

	// les différentes options avec l'initialisation des boutons
	$rootScope.quiz.opts = {
		randQuestion: {yes: false, no: true},
		modes: {training: true, exercise: false, assessment: false, perso: false},
		correction: {afterEach: true, atEnd: false, none: false},
		canRewind: {yes: true, no: false},
		score: {afterEach: true, atEnd: false, none: false},
		canRedo: {yes: true, no: false}
	};

	// ouverture et fermeture de l'accordion
	$scope.open = false;


	// fonction permettante de changer l'état des boutons des options
	$scope.changeRadioButton = function(opt, buttonChanged){
		_.each($rootScope.quiz.opts[opt], function(button, key){
			if (key === buttonChanged) {
				$rootScope.quiz.opts[opt][key] = true;
			} else{
				$rootScope.quiz.opts[opt][key] = false;
			};
		});
	}
	// fonction qui remet les paramètres par défaut
	$scope.reEstablish = function(){
		$scope.changeRadioButton('randQuestion', 'no');
		$scope.changeRadioButton('modes', 'training');
		$scope.changeRadioButton('correction', 'afterEach');
		$scope.changeRadioButton('canRewind', 'yes');
		$scope.changeRadioButton('score', 'afterEach');
		$scope.changeRadioButton('canRedo', 'yes');
	}

	// fonction qui supprime une question
	$scope.deleteQuestion= function(id){
		$rootScope.quiz.questions = _.reject($rootScope.quiz.questions, function(question){
			return question.id == id;
		});
	}
	// fonction qui met à jour une question
	$scope.add = function(){
		$state.go('quizs.create_questions', {quiz_id: $rootScope.quiz.id});
	}
	// fonction qui met à jour une question
	$scope.updateQuestion = function(id){
		$state.go('quizs.update_questions', {quiz_id: $rootScope.quiz.id, id: id});
	}

	// cette fonction permet de renseigner l'odre des questions
	$scope.kanbanSortOptions = {
    orderChanged: function (event) {
    	//pour avoir l'ordre on récupère dans event dest index
    	//et pour l'ancien cest dans event source index
    	//on remplace les sequence des questions par les bonnes
    	$rootScope.quiz.questions[event.dest.index].sequence = event.dest.index
    	$rootScope.quiz.questions[event.source.index].sequence = event.source.index
    	console.log($rootScope.quiz.questions);
    	console.log("le nouvel index : " + event.dest.index);
    	console.log("l'ancien index : " + event.source.index);
    },
    containment: '#board'
  };

	// si on referme les params avancés, on regarde si on a une config prédéfinie ou pas
	$scope.$watch("open", function(newVal, oldVal){
		if (!newVal) {
			//par simplification je récupère les opts dans une variable
			var opts = $rootScope.quiz.opts;
			// on se met par défaut en mode perso
			$scope.changeRadioButton('modes', 'perso');
			//mais si on a une config du mode entrainement on se met dans ce mode
			if (opts.correction.afterEach && opts.canRewind.yes && opts.score.afterEach && opts.canRedo.yes) {
				$scope.changeRadioButton('modes', 'training');
			};
			//pareil pour les autres modes
			if (opts.correction.atEnd && opts.canRewind.no && opts.score.atEnd && opts.canRedo.no) {
				$scope.changeRadioButton('modes', 'exercise');
			};
			if (opts.correction.none && opts.canRewind.no && opts.score.none && opts.canRedo.no) {
				$scope.changeRadioButton('modes', 'assessment');
			};
		};
	});
}]);