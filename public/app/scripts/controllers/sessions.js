'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('SessionsCtrl', ['$scope', '$state', '$stateParams', '$rootScope', 'Notifications', function($scope, $state, $stateParams, $rootScope, Notifications) {
	//variables pour les filtres
	$scope.defaultClass = {id: "!", name: "Toutes"};
	$scope.defaultStudent = {id: "!", name: "Tous"};
	$scope.filters = {
		newest: true,
		oldest: false,
		classe: $scope.defaultClass,
		student: $scope.defaultStudent
	};
	//variables pour les deux selects
	$scope.selectClasses = [];
	$scope.selectStudents = [];
	//on récupère les sessions
	$scope.sessions = $rootScope.sessions;
	//on alimente les selects avec les données réelles des sessions
	if ($scope.sessions) {
		_.each($scope.sessions, function(session){
			if (!_.find($scope.selectClasses, function(classe){
				return classe.id === session.classe.id})
			){
				$scope.selectClasses.push(session.classe);
			};
			if (!_.find($scope.selectStudents, function(student){
				return student.id === session.student.id})
			){
				$scope.selectStudents.push(session.student);
			};
		});
	};
	//si on veut arriver directement sur les sessions d'une classe ou d'un élève,
	//on change les valeurs des selects
	if ($stateParams.rgpt_id != null) {
		var classe = _.find($scope.selectClasses, function(selectClass){
			return selectClass.id == $stateParams.rgpt_id;
		});
		if (classe) {
			$scope.filters.classe = classe;
		};
	};
	if ($stateParams.student_id != null) {
		var student = _.find($scope.selectStudents, function(selectStudent){
			return selectStudent.id == $stateParams.student_id;
		});
		if (student) {
			$scope.filters.student = student;
		};
	};
	//Change l'ordre par date (croissant/décroissant)
	//sert seulement à changer la case mode coché ou décoché
	$scope.changeDate = function(order){
		if (order == "newest") {
			$scope.filters.newest = true;
			$scope.filters.oldest = false;
		} else {
			$scope.filters.newest = false;
			$scope.filters.oldest = true;
		};
	};
	//change la classe courante du select
	$scope.changeClass = function(classe){
		$scope.filters.classe = classe;
	};
	//change l'élève courant du select
	$scope.changeStudent = function(student){
		$scope.filters.student = student;
	};

	//fonction des boutons de l'ihm sessions
	$scope.quiz = function(){
		$state.go('quizs.params', {quiz_id: $stateParams.quiz_id});
	}
	$scope.print = function(){
		//api imprimer les sessions d'un quiz
	}
	$scope.reset = function(){
		//supprime les sessions du quiz
		$scope.sessions = [];
		$scope.selectClasses = [];
		$scope.selectStudents = [];
		//api suppression sessions quiz
	}
	$scope.close = function(){
		$state.go('quizs.home');
	}
}]);