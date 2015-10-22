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
	//variable pour les datepickers
	$scope.fromDate = new Date();
	$scope.minDate = new Date(); 
	$scope.toDate = new Date();
	//variable de modification de publication
	$rootScope.deleted = [];
  $rootScope.added = [];
  //ouvre le datepicker correspondant
  $scope.open = function($event, opened) {
    $scope.status[opened] = true;
  };
  //options des datepickers
  $scope.dateOptions = {
    showWeeks: false,
    startingDay: 1
  };
  //status des datepickers
  $scope.status = {
  	fomDate: false,
  	toDate: false
  };
  // retourne à la liste des quizs
  $scope.back = function(){
  	$state.go('quizs.home');
  }
  //publi un quiz
  $scope.publish = function(){
  	//traitement fait pour la dinamic
  	//si on a des publications
  	if ($rootScope.tmpPublishesRegroupements.length > 0) {
  		//on copie dans une variable de fonction les publications
	  	var tmpPublishesRegroupements = angular.copy($rootScope.tmpPublishesRegroupements);
	  	//on vérifie si l'on a pas supprimé des publications
	  	_.each(angular.copy($scope.quiz.publishes), function(publish){
	  		//on recherche si la publication est toujours existante
	  		var tmpRegroupement = angular.copy(_.find(tmpPublishesRegroupements, function(tmpRgpt){
	  		 	return tmpRgpt.id === publish.id
	  		}));
	  		//si elle n'est plus, on l'enregistre dans les suppressions
	  		if (!tmpRegroupement) {
	  			$rootScope.deleted.push(publish);
	  		};
	  	});
	  	//le reste c'est les ajout et ceux qui n'ont pas été modifié
	  	$rootScope.added = tmpPublishesRegroupements;
	  	//si il y a eu des suppression on demande l'accord 
	  	//de les supprimer à l'utilisateur via une modal
	  	if ($rootScope.deleted.length > 0) {
	  		Modal.open($scope.modalConfirmDeletedPubishCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	  	} else {
	  	//s'il y a que des ajouts on publie.
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
		//controller pour confirmer la suppression de publication avec une modal
		$scope.modalConfirmDeletedPubishCtrl = ["$scope", "$rootScope", "$modalInstance", "$state", "$stateParams", function($scope, $rootScope, $modalInstance, $state, $stateParams){
			$scope.title = "Supprimer les publications";
			//on créé un message personalisé avec tous les nom des publications à supprimer 
			//afin que ce soit claire pour l'utilisateur
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
				for (var i = $rootScope.quizs.length - 1; i >= 0; i--) {
					if ($rootScope.quizs[i].id == $stateParams.quiz_id) {
						$rootScope.quizs[i].publishes = $rootScope.added;					
					};
				};
				$rootScope.deleted = [];
  			$rootScope.added = [];
  			$rootScope.tmpPublishesRegroupements = [];
				$modalInstance.close();
				$state.go('quizs.home');					
			}
		}];
		// ----------------------------------------------------- //
}]);