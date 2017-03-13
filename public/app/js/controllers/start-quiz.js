'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('StartQuizCtrl', ['$scope', '$state', '$stateParams', '$rootScope', 'Notifications', 'Users', 'Quizs', 'QuizsApi', 'QuestionsApi', 'SessionsApi', function($scope, $state, $stateParams, $rootScope, Notifications, Users, Quizs, QuizsApi, QuestionsApi, SessionsApi) {
	//on récupère le types de questions du quiz
	var getTypes = function(){
		var types = [];
		// on parcours les questions et si on trouve un nouveau type 
		//qui n'est pas dans la liste on l'ajoute
		_.each($scope.quiz.questions, function(question){
			if (!_.contains(types, question.type)) {
				types.push(question.type);
			};
		});
		return types;
	};
	//Récupération de la clé d'une option à true
	var getKeyOpt = function(opt){
		var keyOpt = "";
		//on récupère la clé du mode à true
		_.map(opt, function(value, key){
			if (value) {
				keyOpt = key;
			};
		});
		return keyOpt;
	}
	//switch permettant de retourner le libelle correspondant à l'option
	var getLibelleMode = function(mode){
		var name = "";
		switch(mode){
			case "training":
				name = "entrainement";
				break;
			case "exercise":
				name = "exercice";
				break;
			case "assessment":
				name = "évaluation";
				break;
			case "perso":
				name = "personalisé";
				break;
		}
		return name;
	}
	var getLibelleCorrection = function(correction){
		var name = "";
		switch(correction){
			case "afterEach":
				name = "Correction par réponse";
				break;
			case "atEnd":
				name = "Correction à la fin";
				break;
			case "none":
				name = "Pas de correction";
				break;
		}
		return name;
	}
	var getLibelleCanRewind = function(canRewind){
		var name = "";
		switch(canRewind){
			case "yes":
				name = "Modification des réponses";
				break;
			case "no":
				name = "Pas de modifications";
				break;
		}
		return name;
	}
	var getLibelleScore = function(score){
		var name = "";
		switch(score){
			case "afterEach":
				name = "Score par réponse";
				break;
			case "atEnd":
				name = "Score à la fin";
				break;
			case "none":
				name = "Pas de score";
				break;
		}
		return name;
	}
	var getLibelleCanRedo = function(canRedo){
		var name = "";
		switch(canRedo){
			case "no":
				name = "Une seule fois";
				break;
			case "yes":
				name = "A l'infini";
				break;
		}
		return name;
	}
	var getLibelleOpts = function(nameOpt, valueOpt){
		switch(nameOpt){
			case "mode":
				return getLibelleMode(valueOpt);
			case "correction":
				return getLibelleCorrection(valueOpt);
			case "canRewind":
				return getLibelleCanRewind(valueOpt);
			case "score":
				return getLibelleScore(valueOpt);
			case "canRedo":
				return getLibelleCanRedo(valueOpt);
			default:
				return "";
		}
	}
	//récupère le mode ainsi que ces différentes options
	var getMode = function(){
		var mode = "";
		var name = "";
		//on récupère la clé du mode à true
		mode = getKeyOpt($scope.quiz.opts.modes);
		//on récupère le nom du mode afin de l'afficher à l'utilisateur
		name = getLibelleOpts("mode", mode);
		return name;
	};
	//on récupère les options
	var getOpts = function(){
		var keyOpt = "";
		var opts = {
			correction: "",
			canRewind: "",
			score: "",
			canRedo: ""
		};
		//on récupère la clé de l'option que l'on cherche
		_.map(opts, function(value, key){
			// pour récupérer la clé de la valeur à true de l'option
			keyOpt = getKeyOpt($scope.quiz.opts[key]);
			opts[key] = getLibelleOpts(key, keyOpt);
		});
		return opts;
	};
	//informe des différents type de médias présent
	var getMedias = function(){
		var medias = {audio: false, image: false, video: false};
		_.each($scope.quiz.questions, function(question){
			if (question.media.type) {
				medias[question.media.type] = true;
			};
			_.each(question.answers, function(answer){
				if (question.type == "ass"){
					medias[answer.leftProposition.joindre.type] = true;
					medias[answer.rightProposition.joindre.type] = true;
				} else {
					medias[answer.joindre.type] = true;
				};
			});
		});
		return medias
	};

	$scope.start = function(publication_id){
		if ($scope.quiz.opt_rand_question_order) {
			$scope.quiz.questions = Quizs.randQuestions($scope.quiz.questions);
		};
		$rootScope.quiz = angular.copy($scope.quiz);
		SessionsApi.create({publication_id:$stateParams.publication_id}).$promise.then(function(response){
			if (!response.error) {
				$state.go('quizs.read_questions', {quiz_id: $scope.quiz.id ,id: $scope.quiz.questions[0].id, session_id: response.session_created.id ,publication_id:$stateParams.publication_id});				
			};			
		});
	}
	$scope.close = function(){
		$state.go('quizs.home');
	}

	//variables
	//titre de l'action
	$scope.actionTitle = "prêts ? partez !";
	//Récupération du quiz
	QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		if (!response.error) {
			$scope.quiz = response.quiz_found;
			$scope.quiz.opts = Quizs.getFormatOpt(response.quiz_found);
			$scope.quiz.questions = [];
			// si le quiz à pour params de ne le jouer qu'une seul fois et qu'il existe déjà une session pour cette utilisateur, on lance une erreur sauf pour le prof
			if (!response.quiz_found.opt_can_redo && Users.getCurrentUser.roleMaxPriority == 0) {
				SessionsApi.exist({quiz_id: response.quiz_found.id}).$promise.then(function(resp){
					if (resp.exist) {
						$state.go('erreur', {code: "401", message: "Vous ne pouvez exécuter ce quiz qu'une seule fois !"});
					};
				});
			};

			QuestionsApi.getAll({quiz_id: $scope.quiz.id, read: true}).$promise.then(function(responseQuesionApi){
				$scope.quiz.questions = responseQuesionApi.questions_found;
				// les différents types de question dans le quiz
				$scope.types = getTypes();
				//le mode des paramètres du quiz
				$scope.mode = getMode();
				//les différentes paramètres du quiz
				$scope.opts = getOpts();
				//récupère les différents type de médias
				$scope.medias = getMedias();
			});			
		} else {
			$state.go('erreur', {code: "404", message: response.error.msg});
		};
	});
}]);
