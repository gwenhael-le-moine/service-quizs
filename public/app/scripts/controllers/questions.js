'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuestionsCtrl', ['$scope', '$state', '$rootScope', '$stateParams', '$timeout', 'APP_PATH', 'Notifications', 'Upload', 'Modal', 'Line', function($scope, $state, $rootScope, $stateParams, $timeout, APP_PATH, Notifications, Upload, Modal, Line) {

	// -------- initalisation des Variables ------- //
	// type de question
	$scope.types = {qcm: true, tat: false, ass: false};
	// Variable de la question en générale 
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'ajouter une question';
	// place holder pour les input file media
	$scope.placeholderMedia = "Joindre un fichier (image, sons, video...)";
  // Variables vide lorsque l'on veut remettre à zéro
  $rootScope.defaultQuestion = {
  	id: null,
		type: "qcm",
		libelle: null,
		media: null,
		hint: {libelle:null, media: null},
		answers:{},
		randanswer: false,
		comment: null
	};
	$rootScope.defaultSuggestions = {
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
    tat: [
      {
        text: null,
        solution: null,
        ponctuation: null,
        joindre: null
      }
    ],
    leurres: [
    ]
  };
	// Variables pour les ASS
	//id, et coord des deux extrémité de la ligne d'un association
  $scope.connect1 = {id: null, x1: null, y1: null}
  $scope.connect2 = {id: null, x2: null, y2: null}

  //Variable pour les TAT
  //id temporaire
  $rootScope.idtemp = 0;

  // ---------- Fonctions général pour la question ---------//
  // Fonction qui change le type de la question
	$rootScope.changeType = function(type){
		_.each($scope.types, function(button, key){
			if (key == type) {
				$scope.types[key] = true;
				$rootScope.question.type = key;
			} else {
				$scope.types[key] = false;
			};
		});
	}
  // fonction permettant de couper un nom trop long...
  var sizeNameMedia = function(name, lengthMax, lengthLeft, lengthRight){
  	if (name.length > lengthMax) {
  		return name.substring(0,lengthLeft) + " ... " + name.substring(name.length-lengthRight,name.length);
  	};
  	return name;
  }

	// ---------- Les fonctions pour l'upload des médias ----------//
	// permet de choisir un medium en appelant le bouton caché input file !!
	$scope.openFileUpload = function(id){
		angular.element($('#'+id)).click();
	};
	// fonctions permettant d'importer un medium pour chaque type de réponse et question
	$scope.uploadQuestionMedia = function(files){
		if (files[0] && !files[0].$error) {
			$rootScope.question.media = sizeNameMedia(files[0].name, 50, 40, 8);
			uploadMedia(files);
		}
	}
	$scope.uploadHintMedia = function(files){
		if (files[0] && !files[0].$error) {
			$rootScope.question.hint.media = sizeNameMedia(files[0].name, 50, 40, 8);
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
				$rootScope.suggestions.ass[index].leftProposition.joindre = sizeNameMedia(files[0].name, 8, 0, 8);
			} else {
				$rootScope.suggestions.ass[index].rightProposition.joindre = sizeNameMedia(files[0].name, 8, 0, 8);
			};
			uploadMedia(files);
		}
	}
	$scope.uploadSuggestionTATMedia = function(files, index){
		if (files[0] && !files[0].$error) {
			$rootScope.suggestions.tat[index].joindre = sizeNameMedia(files[0].name, 15, 5, 8);
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

  // ---------- Fonctions pour les ASS ---------//
  //modifie l'étape dans l'association(validation du texte et connections des propositions)
  $scope.changeModeAss = function(){
  	//si on revient à l'étape du texte on supprime les relations
  	if ($rootScope.validateAss) {
  		Modal.open($scope.modalConfirmModifSuggestionsCtrl, APP_PATH + '/app/views/modals/confirm.html', 'md'); 
  	} else {
  		$rootScope.validateAss = !$rootScope.validateAss;		  		
  	}
  }
	// fonction permettante de vérifier si il y a au moins une proposition et une solution
	$scope.checkAss = function(){
		return $rootScope.suggestions.ass[0].rightProposition.libelle && $rootScope.suggestions.ass[0].leftProposition.libelle;
	}
  //efface les proposition de l'association 
  $scope.cleanAss = function(){
  	Modal.open($scope.modalConfirmCleanAssCtrl, APP_PATH + '/app/views/modals/confirm.html', 'md');
  }

	// ------- Fonction sur la ligne de connection pour les associations ------- /

	// Fonction qui enregistre le premier point de connection de la ligne, 
	// et lors du deuxième point, elle créé la ligne entre les deux points.
  $scope.connect = function(idElement, typeProposition){
  	//on ne peut créer les liens seulement après avoir valider le texte
  	if ($rootScope.validateAss) {
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
	  		//on regarde si on est en création ou en modification
	  		//si on a aucunes solutions et pas les lignes 
	  		if(_.indexOf($rootScope.suggestions.ass[$scope.connect1.id].leftProposition.solutions, $scope.connect2.id) == -1 && $('#line'+$scope.connect1.id+"_"+$scope.connect2.id).length == 0){
		  		//dans la proposition de gauche la solution et la proposition de droite
		  		$rootScope.suggestions.ass[$scope.connect1.id].leftProposition.solutions.push($scope.connect2.id);
		  		//et inversement dans la proposition de droite
		  		$rootScope.suggestions.ass[$scope.connect2.id].rightProposition.solutions.push($scope.connect1.id);
		  		//on créé la ligne
		  		Line.create($scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2, $scope);
		  	//ou bien si on a déja les solutions dans l'objet mais pas les ligne de créés
		  	} else if (_.indexOf($rootScope.suggestions.ass[$scope.connect1.id].leftProposition.solutions, $scope.connect2.id) != -1 && $('#line'+$scope.connect1.id+"_"+$scope.connect2.id).length == 0){
	  				//on créé la ligne
		  		Line.create($scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2, $scope);
		  	};
	  		//on réinitialise les deux extrémités afin de pouvoir recréer une ligne 
		    $scope.connect1 = {id: null, x1: null, y1: null};
		    $scope.connect2 = {id: null, x2: null, y2: null}; 			
	  	};
	  };
  }
  //supprime une ligne lorsque l'on double click dessus
  $scope.clearLine = function(id){
  	Line.clear(id);
  }


	// --------- Fonction pour les TAT --------/
	// Ajoute une ligne de TAT
	$scope.addTAT = function(){
		$rootScope.suggestions.tat.push({
			text: null,
			solution: null,
			ponctuation: null,
			joindre: null
		});
	}
	// Ajoute un leurre avec une modal
	$scope.addLeurre = function(){
		Modal.open($scope.modalAddLeurreCtrl, APP_PATH+'/app/views/modals/add-change-object.html', 'md');
	}
	// Supprime un leurre par rapport à son Id
	$scope.deleteLeurre = function(id){
		$rootScope.suggestions.leurres = _.reject($rootScope.suggestions.leurres, function(leurre){
			return leurre.id === id;
		})
	}

	// fonction qui vérifie qu'il y a au moins une réponse à la question
	$scope.atLeastOneAnswer = function(typeQuestion){
		var atLeastOne = false;
		switch(typeQuestion){
			case "qcm":
				_.each($rootScope.suggestions.qcm, function(reponse){
					if (reponse.proposition != null && reponse.proposition != "") {
						atLeastOne = true;
					};
				});
				break;
			case "tat":
				_.each($rootScope.suggestions.tat, function(reponse){
					if (reponse.text != null && reponse.text != "" && reponse.solution != null && reponse.solution) {
						atLeastOne = true;
					};
				});
				break;
			case "ass":
				_.each($rootScope.suggestions.ass, function(reponse){
					if (reponse.leftProposition.libelle != null && reponse.leftProposition.libelle != "" && reponse.rightProposition.libelle != null && reponse.rightProposition.libelle) {
						atLeastOne = true;
					};
				});
				break;
		}
		return atLeastOne;
	}

	// ------- Ajoute et efface la questions avec les reponses ------//

  // fonction qui ajoute la question et ses réponse dans le quiz
  $scope.addQuestion = function(){
  	if ($rootScope.question.libelle && $scope.atLeastOneAnswer($rootScope.question.type)) {
  			$rootScope.question.answers = $rootScope.suggestions;
  		if ($rootScope.modeModif) {
  			console.log("modif");
  			for (var i = $rootScope.quiz.questions.length - 1; i >= 0; i--) {
  				if ($rootScope.quiz.questions[i].id === $rootScope.question.id) {
  					$rootScope.quiz.questions[i] = $rootScope.question;
  				};
  			};
  			// var question = _.find($rootScope.quiz.questions, function(q){
  			// 	return q.id === $rootScope.question.id;
  			// });
  			// console.log(question);
  			// question = angular.copy($rootScope.question);
  			// console.log(question);
  		} else {
 				$rootScope.question.id = $rootScope.tmpId++;  			
  			$rootScope.quiz.questions.push($rootScope.question);
  		};
  		$state.go('quizs.params');
  	};
  }
  // fonction qui réinitialise la question et ses réponses
  $scope.cleanQuestion = function(){
  	Modal.open($scope.modalClearQuestionCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
  }

  //l'initialisation de ces variables doit rester a la fin puisqu'elle utilise des fonctions qui doivent être instancié avant
  // selon si on est en modification ou en création on initialise différemment
	if ($stateParams.id) {
		//on récupère la question
		$rootScope.question = angular.copy(_.find($rootScope.quiz.questions, function(q){
			return q.id == $stateParams.id;
		}));
		if ($rootScope.question){
			//on remet les suggestions
			$rootScope.suggestions = angular.copy($rootScope.question.answers);
			//permet de définir si on est en modification ou en création
			$rootScope.modeModif = true;
			//si on modifi une association on recréé les liaison
			if ($rootScope.question.type == "ass") {
				//permet de valider les association pour ensuite les reliers
				$rootScope.validateAss = true;
				//afin de laisser les élément se mettre en place on temporise
				$timeout(function(){
	  			for (var i = $rootScope.suggestions.ass.length - 1; i >= 0; i--) {
						if ($rootScope.suggestions.ass[i].leftProposition.solutions.length > 0) {
							_.each($rootScope.suggestions.ass[i].leftProposition.solutions, function(solution){
								$scope.connect(i, "left");
								$scope.connect(solution, "right");							
							});
						};
					};  		
  			}, 100);
			};
			//remet le type de la question à l'affichage
			$rootScope.changeType($rootScope.question.type)
			//on récupère les réponses
			$rootScope.suggestions = $rootScope.question.answers
		} else {
			$state.go('erreur', {code: "404", message: "La Question n'existe pas !"});
		};
	} else {
		//on est pas en mode modification mais en création
		$rootScope.modeModif = false;
		//permet de valider les association pour ensuite les reliers
		$rootScope.validateAss = false;
		//on initialise la questions et les réponses
		$rootScope.question = angular.copy($rootScope.defaultQuestion);
		$rootScope.suggestions = angular.copy($rootScope.defaultSuggestions);
	};

  // -------------- Controllers Modal des questions --------------- //
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
		//controller pour ajouter un leurre dans la liste avec une modal
		$scope.modalAddLeurreCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = "Ajouter un leurre";
			$scope.text = "";
			$scope.error = "Le leurre ne peut pas être vide !";
			$scope.required = false;
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				$scope.validate = true;
				//si le texte n'est pas vide ou null on l'ajoute au leurres
				if ($scope.text != null && $scope.text != "") {
					$rootScope.suggestions.leurres.push({id: $rootScope.idtemp++, text: $scope.text});
					$modalInstance.close();					
				};				
			}
		}];
		//controller pour effacer toute la quetsion avec une modal
		$scope.modalClearQuestionCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = "Effacer la question";
			$scope.message = "Êtes vous sûr de vouloir effacer toute la question ainsi que ses réponses ?";
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				$rootScope.question = angular.copy($rootScope.defaultQuestion);
		  	$rootScope.suggestions = angular.copy($rootScope.defaultSuggestions);
		  	$(".line").remove();
		  	$rootScope.changeType($rootScope.question.type);
				$rootScope.validateAss = false;				
				$modalInstance.close();					
			}
		}];
		// ----------------------------------------------------- //
}]);