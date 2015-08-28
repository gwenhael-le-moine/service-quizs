'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuestionsCtrl', ['$scope', '$state', '$rootScope', '$compile', 'APP_PATH', 'Notifications', 'Upload', 'Modal', function($scope, $state, $rootScope, $compile, APP_PATH, Notifications, Upload, Modal) {
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'ajouter une question';
	//type de question
	$scope.types = {qcm: false, tat: false, ass: true};
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
	$rootScope.suggestions = {
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
		ass: [
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			},
			{
				leftProposition: {libelle: null, joindre: null, solutions: []}, 
				rightProposition: {libelle: null, joindre: null, solutions: []}
			}
		],
		tat: []
	}
	//permet de valider les association pour ensuite les reliers
	$rootScope.validateAss = false;
	//id, et coord des deux extrémité de la ligne d'un association
  $scope.connect1 = {id: null, x1: null, y1: null}
  $scope.connect2 = {id: null, x2: null, y2: null}

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
			$scope.question.media = sizeNameMedia(files[0].name, 50, 40, 8);
			uploadMedia(files);
		}
	}
	$scope.uploadHintMedia = function(files){
		if (files[0] && !files[0].$error) {
			$scope.question.hint.media = sizeNameMedia(files[0].name, 50, 40, 8);
			uploadMedia(files);
		}
	}
	$scope.uploadSuggestionQCMMedia = function(files, index){
		if (files[0] && !files[0].$error) {
			$rootScope.suggestions.qcm[index].joindre = sizeNameMedia(files[0].name, 30, 22, 8);
			uploadMedia(files);
		}
	}
	$scope.uploadSuggestionASSMedia = function(files, index, direction){
		if (files[0] && !files[0].$error) {
			if (direction === 'left') {
				$rootScope.suggestions.ass[index].leftProposition.joindre = sizeNameMedia(files[0].name, 11, 0, 11);
			} else {
				$rootScope.suggestions.ass[index].rightProposition.joindre = sizeNameMedia(files[0].name, 11, 0, 11);
			};
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
  var sizeNameMedia = function(name, lengthMax, lengthLeft, lengthRight){
  	if (name.length > lengthMax) {
  		return name.substring(0,lengthLeft) + " ... " + name.substring(name.length-lengthRight,name.length);
  	};
  	return name;
  }
  //modifie l'étape dasn l'association
  $scope.changeModeAss = function(){
  	//si on revient à l'étape du texte on supprime les relations
  	if ($rootScope.validateAss) {
  		Modal.open($scope.modalConfirmModifSuggestionsCtrl, APP_PATH + '/app/views/modals/confirm.html', 'md');  		
  	} else {
  		$rootScope.validateAss = !$rootScope.validateAss;  		
  	};
  }
  //efface les proposition de l'association 
  $scope.cleanAss = function(){
  	Modal.open($scope.modalConfirmCleanAssCtrl, APP_PATH + '/app/views/modals/confirm.html', 'md');
  }


  $scope.connect = function(idElement, typeProposition){
  	//on ne peut créer les liens seulement après avoir valider le texte
  	if ($rootScope.validateAss) {
	  	//on récupère les coordonnées de l'élément
	  	var element = angular.element($('#'+typeProposition+"connect"+idElement));
	  	var xElement = element.offset().left + element.width() / 2;
	  	var yElement = element.offset().top + element.height() / 2;
	  	// on enregistre les point de connections
	  	if (typeProposition === 'left') {
	  		$scope.connect1.id = idElement;
	  		$scope.connect1.x1 = xElement;
	  		$scope.connect1.y1 = yElement;
	  	} else {
	  		$scope.connect2.id = idElement
	  		$scope.connect2.x2 = xElement;
	  		$scope.connect2.y2 = yElement;
	  	};
	  	//seulement lorsque l'on a les deux points, on créé la ligne et on enregistre les solutions
	  	if ($scope.connect1.x1 != null && $scope.connect1.y1 != null && $scope.connect2.x2 != null && $scope.connect2.y2 != null) {
	  		//on regarde si le liens n'a pas déjà été créé
	  		if(_.indexOf($rootScope.suggestions.ass[$scope.connect1.id].leftProposition.solutions, $scope.connect2.id) == -1){
		  		//dans la proposition de gauche la solution et la proposition de droite
		  		$rootScope.suggestions.ass[$scope.connect1.id].leftProposition.solutions.push($scope.connect2.id);
		  		//et inversement dans la droite
		  		$rootScope.suggestions.ass[$scope.connect2.id].rightProposition.solutions.push($scope.connect1.id);
		  		//on créé la ligne
		  		createLine($scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2);	  			
	  		}
	  	};
	  };
  }
  //supprime une ligne lorsque l'on double click dessus
  $scope.clearLine = function(id){
  	//on supprime la ligne
  	$('#'+id).remove();
  	//dans l'id du div qui compose la ligne, il y a l'id de la prop gauchet et de droite
  	//afin qu'avec un simple split nous puissons le récupérer
  	var idLeftProposition = id.split('line')[1].split('_')[0];
  	var idRightProposition = id.split('line')[1].split('_')[1];
  	//on peut maintenant supprimer la solution dans chaque proposition correpondant à la ligne
  	$rootScope.suggestions.ass[idLeftProposition].leftProposition.solutions = _.reject($rootScope.suggestions.ass[idLeftProposition].leftProposition.solutions, function(solution){
  		return solution == idRightProposition;
  	});
  	$rootScope.suggestions.ass[idRightProposition].rightProposition.solutions = _.reject($rootScope.suggestions.ass[idRightProposition].rightProposition.solutions, function(solution){
  		return solution == idLeftProposition;
  	});
  }

  //fonction permettant de créer une ligne avec un div que l'on injecte dans la page
  function createLine(id, x1, y1, x2, y2){
  	//calcule de la longueur et de l'angle de la ligne
    var length = Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
	  var angle  = Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
	  //valeur css du transfor afin de dessiner la ligne
	  var transform = 'rotate('+angle+'deg)';
	  //injection de la ligne dans la page
    $('#linesId').append($compile(angular.element('<div id="line'+id+'" ng-dblclick="clearLine(\'line'+id+'\')"></div>'))($scope));	      
    //ajout des classes css afin que la ligne ai l'aspect voulu
	  $('#line'+id).addClass('line')
    .css({
      'position': 'absolute',
      'transform': transform,
    })
    .width(length)
    .offset({left: x1, top: y1});
    
    //on réinitialise les deux extrémités afin de pouvoir recréer une ligne	
    $scope.connect1 = {id: null, x1: null, y1: null}
  	$scope.connect2 = {id: null, x2: null, y2: null}
	}
	// fonction permettante de vérifier si il y a au moins une proposition et une solution
	$scope.checkAss = function(){
		return $rootScope.suggestions.ass[0].rightProposition.libelle && $rootScope.suggestions.ass[0].leftProposition.libelle;
	}
  // fonction qui ajoute la question et ses réponse dans le quiz
  $scope.addQuestion = function(){
  	
  }
  // fonction qui réinitialise la question et ses réponses
  $scope.cleanQuestion = function(){
  	
  }

  // -------------- Controllers Modal des quizs --------------- //
		//controller pour effacer les données de l'association avec une modal
		$scope.modalConfirmCleanAssCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = "Effacer les données";
			$scope.message = "Êtes vous sûr de vouloir effacer les propositions, solutions liées et médias de l'association ?";
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){	
				//on remet l'association à son état initiale
				for (var i = $rootScope.suggestions.ass.length - 1; i >= 0; i--) {
					$rootScope.suggestions.ass[i].leftProposition.libelle = null;
					$rootScope.suggestions.ass[i].leftProposition.joindre = null;
					$rootScope.suggestions.ass[i].leftProposition.solutions = [];
					$rootScope.suggestions.ass[i].rightProposition.libelle = null;
					$rootScope.suggestions.ass[i].rightProposition.joindre = null;
					$rootScope.suggestions.ass[i].rightProposition.solutions = [];
				};  		
				//on supprime les liens déjà créés
				$(".line").remove();			
				$modalInstance.close();					
			}
		}];
		//controller pour effacer les données de de la question avec une modal
		$scope.modalConfirmCleanQuestionCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = "Effacer les données";
			$scope.message = "Êtes vous sûr de vouloir effacer toutes les données de la questions ?";
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){				
				$modalInstance.close();					
			}
		}];
		//controller pour effacer les données de l'association lorsque l'on change le texte après l'avoir valider avec une modal
		$scope.modalConfirmModifSuggestionsCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = "Modifier le texte";
			$scope.message = "Modifier le texte, vous fera perdre tous vos liens ! \n Êtes vous sûr de vouloir le modifier ?";
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				//on supprime les solutions
	  		for (var i = $rootScope.suggestions.ass.length - 1; i >= 0; i--) {
			  	$rootScope.suggestions.ass[i].leftProposition.solutions = [];
			  	$rootScope.suggestions.ass[i].rightProposition.solutions = [];
			  };
			  //on supprime les lignes
				$(".line").remove();
				$rootScope.validateAss = !$rootScope.validateAss;				
				$modalInstance.close();					
			}
		}];
		// ----------------------------------------------------- //
}]);