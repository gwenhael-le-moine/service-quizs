'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('AsidePublishCtrl', ['$scope', '$state', '$stateParams', '$rootScope', '$timeout', 'APP_PATH', 'Notifications', 'Modal', function($scope, $state, $stateParams, $rootScope, $timeout, APP_PATH, Notifications, Modal) {
	// pour la dynamic de l'ihm on récupère le quiz dans la listes
	//afin de simplifier en final version on récupérera seulement le quiz 
	//avec une api
	$scope.quiz = angular.copy(_.find($rootScope.quizs, function(q){
		return q.id == $stateParams.quiz_id;
	}));
	if (!$scope.quiz) {
		$state.go('erreur', {code: "404", message: "Le quiz n'existe pas !"});
	};
	$scope.fromDate = new Date();
	$scope.minDate = new Date(); 
	$scope.toDate = new Date();

	$rootScope.deleted = [];
  $rootScope.added = [];

  $scope.open = function($event, opened) {
    $scope.status[opened] = true;
  };
  $scope.dateOptions = {
    showWeeks: false,
    startingDay: 1
  };
  $scope.status = {
  	fomDate: false,
  	toDate: false
  };

  $scope.back = function(){
  	$state.go('quizs.home');
  }
  $scope.publish = function(){
  	//traitement fait pour la dinamic
  	if ($rootScope.tmpPublishesRegroupements.length > 0) {
	  	var tmpPublishesRegroupements = angular.copy($rootScope.tmpPublishesRegroupements);
	  	_.each(angular.copy($scope.quiz.publishes), function(publish){
	  		var tmpRegroupement = angular.copy(_.find(tmpPublishesRegroupements, function(tmpRgpt){
	  		 	return tmpRgpt.id === publish.id
	  		}));
	  		if (!tmpRegroupement) {
	  			$rootScope.deleted.push(publish);
	  		};
	  	});
	  	$rootScope.added = angular.copy(tmpPublishesRegroupements);
	  	console.log($rootScope.added);
	  	tmpPublishesRegroupements = [];
	  	if ($rootScope.deleted.length > 0) {
	  		Modal.open($scope.modalConfirmDeletedPubishCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	  	} else {
	  		for (var i = $rootScope.quizs.length - 1; i >= 0; i--) {
					if ($rootScope.quizs[i].id == $stateParams.quiz_id) {
						$rootScope.quizs[i].publishes = $rootScope.added;					
					};
				};
				$state.go('quizs.home');
	  	};
  	};
  }

  // -------------- Controllers Modal des quizs --------------- //
		//controller pour changer le titre du quiz avec une modal
		$scope.modalConfirmDeletedPubishCtrl = ["$scope", "$rootScope", "$modalInstance", "$state", "$stateParams", function($scope, $rootScope, $modalInstance, $state, $stateParams){
			$scope.title = "Supprimer les publications";
			var getStringDeletedPublihes = function(){
				var string = "";
				if ($rootScope.deleted.length == 1) {
					string = " la publication '"+$rootScope.deleted[0].name.toUpperCase()+"' du collège '"+$rootScope.deleted[0].nameEtab.toUpperCase()+"'";
				} else {
					string = " les publications";
					_.each($rootScope.deleted, function(d){
						string += " '"+d.name.toUpperCase()+"' du collège '"+d.nameEtab.toUpperCase()+"',";
					});
					string = string.substring(0, string.length-1);
				};
				return string;
			};
			$scope.message = "Êtes vous sûr de vouloir supprimer "+getStringDeletedPublihes()+" ?";
			$scope.no = function(){
				$rootScope.deleted = [];
  			$rootScope.added = [];
				$modalInstance.close();
			}
			$scope.ok = function(){
				console.log($stateParams.id);
				for (var i = $rootScope.quizs.length - 1; i >= 0; i--) {
					if ($rootScope.quizs[i].id == $stateParams.quiz_id) {
						$rootScope.quizs[i].publishes = $rootScope.added;					
					};
				};
				console.log($rootScope.quizs);
				$rootScope.deleted = [];
  			$rootScope.added = [];
  			$rootScope.tmpPublishesRegroupements = [];
				$modalInstance.close();
				$state.go('quizs.home');					
			}
		}];
		// ----------------------------------------------------- //
}]);