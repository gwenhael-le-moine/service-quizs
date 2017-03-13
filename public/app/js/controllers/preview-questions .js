'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('PreviewQuestionsCtrl', ['$scope', '$state', '$rootScope', '$stateParams', '$sce', 'APP_PATH', 'Notifications','Line', 'Modal', 'Quizs', function($scope, $state, $rootScope, $stateParams, $sce, APP_PATH, Notifications, Line, Modal, Quizs) {

	//toutes les réponses à mettre dans les selects
	$scope.selectOptions = [];
	//id, et coord des deux extrémité de la ligne d'un association
  $scope.connect1 = {id: null, x1: null, y1: null};
  $scope.connect2 = {id: null, x2: null, y2: null};
  
	if ($rootScope.previewQuestion) {
		$scope.actionTitle = "Prévisualisation de la question";
		//onn récupère les solutions et les leurres
		$scope.selectOptions = Quizs.getPreviewSolutionTAT();		
		//on récupère la question
		$scope.question = Quizs.sanitizePreviewQuestion();
	};
	if (!$scope.question){
		$state.go('erreur', {code: "404", message: "La question n'existe pas !"});
	}

	//ouvre la modal pour afficher le média
	$scope.displayMedia = function(title, file, type, mime){
		$rootScope.media = {title: title, file: file, type: type, mime: mime};
		Modal.open($scope.modalDisplayMediaCtrl, APP_PATH + '/app/views/modals/display-media.html', 'lg');
	}

	//lit un media audio
	$scope.play = function(src){
		//on récupère la balise audio
		var audie = $('#audioId').get(0);
		// si on a la même source la laisse sinon on met a jour la source
		if (!audie.src || audie.src !== src) {
			audie.src = $sce.trustAsResourceUrl(src);			
		};
		// permet de mettre pause en recliquant dessus
		if (audie.paused == false) {
			audie.pause();
		} else {
			audie.play();			
		};
	}
	//fonction permettant de quitter la preview 
	$scope.quit = function(){
		if ($scope.question.id) {
	 		$state.go('quizs.update_questions', {quiz_id: $rootScope.quiz.id, id: $scope.question.id});			
		} else {
			$state.go('quizs.create_questions', {quiz_id: $rootScope.quiz.id});
		};
	}

	// ------- Fonction sur la ligne de connection pour les associations ------- /

	// Fonction qui enregistre le premier point de connection de la ligne, 
	// et lors du deuxième point, elle créé la ligne entre les deux points.
  $scope.connect = function(idElement, typeProposition){
  	//on récupère les coordonnées de l'élément
  	var element = angular.element($('#'+typeProposition+"connect"+idElement));
  	var xElement = element.offset().left + element.width() / 2;
  	var yElement = element.offset().top + element.height() / 2;
  	// on enregistre les point de connections
  	if (typeProposition === 'left') {
  		$scope.connect1 = {id: idElement, x1: xElement, y1: yElement};
  	} else {
  		$scope.connect2 = {id: idElement, x2: xElement, y2: yElement};
  	};
  	//seulement lorsque l'on a les deux points, on créé la ligne et on enregistre les solutions
  	if ($scope.connect1.x1 != null && $scope.connect1.y1 != null && $scope.connect2.x2 != null && $scope.connect2.y2 != null) {
			//dans la proposition de gauche la solution et la proposition de droite
  		$scope.question.answers[$scope.connect1.id].leftProposition.solutions.push($scope.connect2.id);
  		//et inversement dans la proposition de droite
  		$scope.question.answers[$scope.connect2.id].rightProposition.solutions.push($scope.connect1.id);
  		//on créé la ligne
  		Line.create('previewLinesId', $scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2, $scope);
  		//on réinitialise les deux extrémités afin de pouvoir recréer une ligne 
	    $scope.connect1 = {id: null, x1: null, y1: null};
	    $scope.connect2 = {id: null, x2: null, y2: null}; 			
  	};
  }
  //supprime une ligne lorsque l'on double click dessus
  $scope.clearLine = function(id){
  	$('#'+id).remove();
  	//dans l'id du div qui compose la ligne, il y a l'id de la prop gauchet et de droite
    //afin qu'avec un simple split nous puissons le récupérer
    var idLeftProposition = id.split('line')[1].split('_')[0];
    var idRightProposition = id.split('line')[1].split('_')[1];
    //on peut maintenant supprimer la solution dans chaque proposition correpondant à la ligne
    $scope.question.answers[idLeftProposition].leftProposition.solutions = _.reject($scope.question.answers[idLeftProposition].leftProposition.solutions, function(solution){
      return solution == idRightProposition;
    });
    $scope.question.answers[idRightProposition].rightProposition.solutions = _.reject($scope.question.answers[idRightProposition].rightProposition.solutions, function(solution){
      return solution == idLeftProposition;
    });
  }

  //change de solution dans la liste mais aussi dans les solutions de l'élève
  $scope.changeSolution = function(index, id, label){
  	if (id === -1 && label === "") {
  		$scope.question.answers[index].currentSelectSolution = "--------";
  	} else {
  		$scope.question.answers[index].currentSelectSolution = label;
  		$scope.question.answers[index].solution = {id: id, libelle: label};
  	};
  }

	// -------------- Controllers Modal des questions --------------- //
		//controller pour afficher les médias avec une modal
		$scope.modalDisplayMediaCtrl = ["$scope", "$rootScope", "$uibModalInstance", function($scope, $rootScope, $uibModalInstance){
			$scope.title = $rootScope.media.title;
			$scope.file = function() {
				if ($rootScope.media.type != "video") {
		    	return $sce.trustAsResourceUrl($rootScope.media.file);
		    } else {
		    	return $sce.trustAsHtml($rootScope.media.file)	
				};
		  }
			$scope.mime = $rootScope.media.mime;
			$scope.type = $rootScope.media.type.split("/")[0];
			$scope.close = function(){
				$uibModalInstance.close();
			}
		}];
}]);
