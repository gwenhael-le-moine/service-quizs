'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('CreateUpdateQuestionsCtrl', ['$scope', '$state', '$rootScope', '$stateParams', '$timeout', 'APP_PATH', 'MAX_FILE_SIZE', 'PATTERN_FILE', 'Notifications', 'Upload', 'Modal', 'Line', 'State', 'Questions', 'QuestionsApi', function($scope, $state, $rootScope, $stateParams, $timeout, APP_PATH, MAX_FILE_SIZE, PATTERN_FILE, Notifications, Upload, Modal, Line, State, Questions, QuestionsApi) {

	// -------- initalisation des Variables ------- //
	//Valeur à respecter pour les fichiers
	$scope.maxFileSize = MAX_FILE_SIZE;
	$scope.patternFile = PATTERN_FILE;
	$scope.errorFileQCM = [];
	$scope.errorFileASS = {'left':[], 'right': []};
	$scope.errorFileTAT = [];
	// type de question
	$scope.types = {qcm: true, tat: false, ass: false};
	// Variable de la question en générale 
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'ajouter une question';
	// placeholder pour les input file media
	$scope.placeholderMedia = "Joindre un fichier (image ou son)";
	$scope.placeholderLink = "Joindre un lien (image, son, video...)";
  
  //le dernier leurre supprimé
  $scope.lastDeleteLeurre = {};
  //promise d'un time out permettant de l'annuler
  var promiseTimeOut = "";
	//id, et coord des deux extrémité de la ligne d'un association
  $scope.connect1 = {id: null, x1: null, y1: null}
  $scope.connect2 = {id: null, x2: null, y2: null}

  //Variable pour les leurres
  //id temporaire
  $rootScope.idLeurreTmp = "tmp_0";

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
  //fonction permettant de retourner les erreurs lié a l'importation d'un fichier
  var checkErrorsFile = function(file){
  	if (file.$error == 'maxSize'){
  		return "La taille maximum autorisée est de "+file.$errorParam+" !";
  	}
  	if (file.$error == 'pattern'){
  		return "Seuls les images et audios sont autorisés !";
  	}
  	return null; 
  }

	// ---------- Les fonctions pour l'upload des médias ----------//
	// permet de choisir un medium en appelant le bouton caché input file !!
	$scope.openFileUpload = function(id){
		angular.element($('#'+id)).click();
	};
	// fonctions permettant d'importer un medium pour chaque type de réponse et question
	$scope.uploadQuestionMedia = function(file){
		if ( file ) $scope.errorFileQuestion = checkErrorsFile(file);
		if (file && !file.$error) {
			$rootScope.question.media.file = {};
			//on enregistre les données du fichier
			$rootScope.question.media.file.name = sizeNameMedia(file.name, 25, 11, 11);
			$rootScope.question.media.file.url = window.URL.createObjectURL(file);
			$rootScope.question.media.mime = file.type;
			$rootScope.question.media.type = file.type.split("/")[0];
			uploadMedia(file);
		}
	}
	$scope.uploadHintMedia = function(file){
		if ( file ) $scope.errorFileHint = checkErrorsFile(file);
		if (file && !file.$error) {
			$rootScope.question.hint.media.file = {};
			//on enregistre les données du fichier
			$rootScope.question.hint.media.file.name = sizeNameMedia(file.name, 25, 11, 11);
			$rootScope.question.hint.media.file.url = window.URL.createObjectURL(file);
			$rootScope.question.hint.media.mime = file.type;
			$rootScope.question.hint.media.type = file.type.split("/")[0];
			uploadMedia(file);
		}
	}
	$scope.uploadSuggestionQCMMedia = function(file, index){
		if ( file ) $scope.errorFileQCM[index] = checkErrorsFile(file);
		if (file && !file.$error) {
			$rootScope.suggestions.qcm[index].joindre.file = {};
			//on enregistre les données du fichier
			$rootScope.suggestions.qcm[index].joindre.file.name = sizeNameMedia(file.name, 30, 22, 8);
			$rootScope.suggestions.qcm[index].joindre.file.url = window.URL.createObjectURL(file);
			$rootScope.suggestions.qcm[index].joindre.mime = file.type;
			$rootScope.suggestions.qcm[index].joindre.type = file.type.split("/")[0];
			uploadMedia(file);
		}
	}
	$scope.uploadSuggestionASSMedia = function(file, index, direction){
		if ( file ) $scope.errorFileASS[direction][index] = checkErrorsFile(file);
		if (file && !file.$error) {
			if (direction === 'left') {
				$rootScope.suggestions.ass[index].leftProposition.joindre.file = {};
				$rootScope.suggestions.ass[index].leftProposition.joindre.file.name = sizeNameMedia(file.name, 8, 0, 8);
				$rootScope.suggestions.ass[index].leftProposition.joindre.file.url = window.URL.createObjectURL(file);
				$rootScope.suggestions.ass[index].leftProposition.joindre.mime = file.type;
				$rootScope.suggestions.ass[index].leftProposition.joindre.type = file.type.split("/")[0];
			} else {
				$rootScope.suggestions.ass[index].rightProposition.joindre.file = {};
				$rootScope.suggestions.ass[index].rightProposition.joindre.file.name = sizeNameMedia(file.name, 8, 0, 8);
				$rootScope.suggestions.ass[index].rightProposition.joindre.file.url = window.URL.createObjectURL(file);
				$rootScope.suggestions.ass[index].rightProposition.joindre.mime = file.type;
				$rootScope.suggestions.ass[index].rightProposition.joindre.type = file.type.split("/")[0];
			};
			uploadMedia(file);
		}
	}
	$scope.uploadSuggestionTATMedia = function(file, index){
		if ( file ) $scope.errorFileTAT[index] = checkErrorsFile(file);
		if (file && !file.$error) {
			$rootScope.suggestions.tat[index].joindre.file = {};
			$rootScope.suggestions.tat[index].joindre.file.name = sizeNameMedia(file.name, 15, 5, 8);
			$rootScope.suggestions.tat[index].joindre.file.url = window.URL.createObjectURL(file);
			$rootScope.suggestions.tat[index].joindre.mime = file.type;
			$rootScope.suggestions.tat[index].joindre.type = file.type.split("/")[0];
			uploadMedia(file);
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
		  		Line.create('linesId', $scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2, $scope);
		  	//ou bien si on a déja les solutions dans l'objet mais pas les ligne de créés
		  	} else if (_.indexOf($rootScope.suggestions.ass[$scope.connect1.id].leftProposition.solutions, $scope.connect2.id) != -1 && $('#line'+$scope.connect1.id+"_"+$scope.connect2.id).length == 0){
	  				//on créé la ligne
		  		Line.create('linesId', $scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2, $scope);
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
			solution: {id: null, libelle: null},
			joindre: {file: null, type: null}
		});
	}
	// Ajoute un leurre avec une modal
	$scope.addLeurre = function(){
		Modal.open($scope.modalAddLeurreCtrl, APP_PATH+'/app/views/modals/add-change-object.html', 'md');
	}
	// Supprime un leurre par rapport à son Id
	$scope.deleteLeurre = function(id){
		$rootScope.suggestions.leurres = _.reject($rootScope.suggestions.leurres, function(leurre){
			if (leurre.id === id) {
				$scope.lastDeleteLeurre = leurre;
				$scope.showBackLeurre = true;
				promiseTimeOut = $timeout(function(){
	  			$scope.showBackLeurre = false;		
  			}, 5000);
			};
			return leurre.id === id;
		})
	}
	//annule la suppresion du dernier leurre
	$scope.backLeurre = function(){
		$rootScope.suggestions.leurres.push(angular.copy($scope.lastDeleteLeurre));
		$scope.showBackLeurre = false;
		$timeout.cancel(promiseTimeOut);
		$scope.lastDeleteLeurre = {};
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

	// Preview de la question
	$scope.preview = function(){
		//on sauvegarde l'état du scope et du root
		State.saveScope($scope);
		State.saveRootScope($rootScope);
		//comme on peut avoir modifier des données,
		//on ajoute les suggestions du type dans la question
		$rootScope.question.answers = angular.copy($rootScope.suggestions[$rootScope.question.type]);
		$rootScope.question.leurres = angular.copy($rootScope.suggestions.leurres);
		//on copi la question dans la preview
		$rootScope.previewQuestion = angular.copy($rootScope.question);
		//on passe dans l'etat de prévisualisation
		if ($scope.modeModif) {
			$state.go('quizs.preview_update_questions', {quiz_id: $rootScope.quiz.id, id: $rootScope.previewQuestion.id});
		} else {
			$state.go('quizs.preview_create_questions', {quiz_id: $rootScope.quiz.id});
		};
	}

	// ------- Ajoute et efface la questions avec les reponses ------//

  // fonction qui ajoute la question et ses réponse dans le quiz
  $scope.addQuestion = function(){
  	//on verifie que l'on a au moins une réponse
  	if ($rootScope.question.libelle && $scope.atLeastOneAnswer($rootScope.question.type)) {
			//on ajoute les suggestions du type dans la question
			$rootScope.question.answers = $rootScope.suggestions[$rootScope.question.type];
			$rootScope.question.leurres = $rootScope.suggestions.leurres;
  			$rootScope.quiz.questions[0] = $rootScope.question;
 				if ($rootScope.modeModif) {
 					QuestionsApi.update({quiz: $rootScope.quiz});
 				} else {
  				QuestionsApi.create({quiz: $rootScope.quiz});
 				};  			
  		// };
  		$state.go('quizs.params', {quiz_id: $rootScope.quiz.id});
  	};
  }
  //fonction qui retourne au paramètres
  $scope.backParams = function(){
  	Modal.open($scope.modalClearQuestionCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
  }


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
					$rootScope.suggestions.ass[i].leftProposition.joindre.file = null;
					$rootScope.suggestions.ass[i].leftProposition.solutions = [];
					$rootScope.suggestions.ass[i].rightProposition.libelle = null;
					$rootScope.suggestions.ass[i].rightProposition.joindre.file = null;
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
					var nb = parseInt($rootScope.idLeurreTmp.split('_')[1]);
					$rootScope.idLeurreTmp = $rootScope.idLeurreTmp.split('_')[0] + "_" + ++nb;
					$rootScope.suggestions.leurres.push({id: $rootScope.idLeurreTmp, libelle: $scope.text});
					$modalInstance.close();					
				};				
			}
		}];
		//controller pour effacer toute la quetsion avec une modal
		$scope.modalClearQuestionCtrl = ["$scope", "$rootScope", "$modalInstance", "Questions", function($scope, $rootScope, $modalInstance, Questions){
			$scope.title = "Annuler la question";
			$scope.message = "Êtes vous sûr de vouloir annuler ?";
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				$state.go('quizs.params', {quiz_id: $rootScope.quiz.id});			
				$modalInstance.close();					
			}
		}];
		// ----------------------------------------------------- //


 	// l'initialisation de ces variables doit rester a la fin puisqu'elle utilise des fonctions qui doivent être instancié avant
	// Si on est en mode création, stateParams.id est null et que l'on revient pas d'une préview
	if (!$rootScope.previewQuestion) {
		//mode création
		if (!$stateParams.id) {
			//on est pas en mode modification mais en création
			$rootScope.modeModif = false;
			//permet de valider les association pour ensuite les reliers
			$rootScope.validateAss = false;
			//on initialise la questions et les réponses
			$rootScope.question = Questions.getDefaultQuestion();
			$rootScope.suggestions = Questions.getDefaultSuggestions();
		// mode update
		} else {
			//on récupère la question
			QuestionsApi.get({id: $stateParams.id}).$promise.then(function(response){
				$rootScope.question = response.question_found;
				if ($rootScope.question){
					//on remet les suggestions tout en noubliant pas de remettre les suggestions des autre type que celle de la question
					$rootScope.suggestions = Questions.getDefaultSuggestions();
					$rootScope.suggestions[$rootScope.question.type] = angular.copy($rootScope.question.answers);
					$rootScope.suggestions.leurres = angular.copy($rootScope.question.leurres);
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
		  			}, 500);
					};
					//remet le type de la question à l'affichage
					$rootScope.changeType($rootScope.question.type)
				} else {
					$state.go('erreur', {code: "404", message: "La question n'existe pas !"});
				};
			});
		};
	} else {
		//on efface les données de preview
		$rootScope.previewQuestion = null;
		//on regarde si on est en création ou pas
		$rootScope.modeModif = false;
		if ($stateParams.id) $rootScope.modeModif = true;
		// on restore l'état du scope avant la preview
		$scope.types = State.restoreScope().types;
		$rootScope.validateAss = false;
		$rootScope.question = State.restoreRootScope().question;
		$rootScope.suggestions = State.restoreRootScope().suggestions;
		$rootScope.idLeurreTmp = State.restoreRootScope().idtemp;
	};
}]);