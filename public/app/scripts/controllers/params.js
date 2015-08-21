'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('ParamsCtrl', ['$scope', '$state', '$rootScope', 'Notifications', function($scope, $state, $rootScope, Notifications) {
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'paramètres';

	// les différentes options avec l'initialisation des boutons
	$scope.opts = {
		randQuestion: {yes: false, no: true},
		modes: {training: true, exercise: false, assessment: false},
		correction: {afterEach: true, atEnd: false, none: false},
		canRewind: {yes: true, no: false},
		score: {afterEach: true, atEnd: false, none: false},
		canRedo: {yes: true, no: false}
	};

	// ouverture et fermeture de l'accordion
	$scope.open = false;

	// fonction permettante de changer l'état des boutons des options
	$scope.changeRadioButton = function(opt, buttonChanged){
		_.each($scope.opts[opt], function(button, key){
			if (key === buttonChanged) {
				$scope.opts[opt][key] = true;
			} else{
				$scope.opts[opt][key] = false;
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
}]);