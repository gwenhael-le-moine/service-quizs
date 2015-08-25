'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuestionsCtrl', ['$scope', '$state', '$rootScope', 'Notifications', 'Upload', function($scope, $state, $rootScope, Notifications, Upload) {
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'ajouter une question';
	//type de question
	$scope.types = {qcm: true, tat: false, ass: false};
	//place holder pour les input file media
	$scope.placeholderMedia = "Joindre un fichier (image, sons, video...)";
	//la question
	$scope.question = {
		type: null,
		libelle: "",
		media: null,
		hint: {libelle:"", media: null},
		randanswer: false,
		comment: ""
	};
	// les suggestions
	$scope.suggestions = {
		qcm: [
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null},
			{solution: false, proposition: "", joindre: null}
		],
		ass: [],
		tat: []
	}

	// fonction permettante de changer le type de question
	$scope.changeType = function(type){
		_.each($scope.types, function(button, key){
			if (key === type) {
				$scope.types[key] = true;
			} else {
				$scope.types[key] = false;
			};
		});
	}
	// permet de choisir un media
	$scope.openFileUpload = function(id){
		angular.element($('#'+id)).click();
	};
	// fonctions permettant d'importer un medium 
	$scope.uploadQuestionMedia = function(files){
		if (files[0] && !files[0].$error) {
				$scope.question.media = sizeNameMedia(files[0].name);
				uploadMedia(files);
		}
	}
	$scope.uploadHintMedia = function(files){
		if (files[0] && !files[0].$error) {
				$scope.question.hint.media = sizeNameMedia(files[0].name);
				uploadMedia(files);
		}
	}
	$scope.uploadSuggestionQCMMedia = function(files, index){
		if (files[0] && !files[0].$error) {
				$scope.suggestions.qcm[index].joindre = sizeNameMedia(files[0].name);
				uploadMedia(files);
		}
	}
	// importe le medium
	var uploadMedia = function (files) {
    // Upload.upload({
    //     url: 'upload/url',
    //     fields: {'username': $scope.username},
    //     file: file
    // }).progress(function (evt) {
    //     var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
    //     console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
    // }).success(function (data, status, headers, config) {
    //     console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
    // }).error(function (data, status, headers, config) {
    //     console.log('error status: ' + status);
    // })
  };
  // fonction permettant de couper un nom trop long...
  var sizeNameMedia = function(name){
  	if (name.length > 25) {
  		return name.substring(0,15) + " ... " + name.substring(name.length-8,name.length);
  	};
  	return name;
  }
  // fonction qui ajoute la question et ses réponse dans le quiz
  $scope.addQuestion = function(){
  	
  }
}]);