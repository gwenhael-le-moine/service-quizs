'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('StartQuizCtrl', ['$scope', '$state', '$rootScope', 'Notifications', function($scope, $state, $rootScope, Notifications) {
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
			case "None":
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
			case "None":
				name = "Pas de score";
				break;
		}
		return name;
	}
	var getLibelleCanRedo = function(canRedo){
		var name = "";
		switch(canRedo){
			case "yes":
				name = "Une seule fois";
				break;
			case "no":
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
		var medias = {audio: false, image: false};
		_.each($scope.quiz.questions, function(question){
			if (question.media.type) {
				medias[question.media.type] = true;
			};
			if (question.hint.media.type) {
				medias[question.hint.media.type] = true;
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

	//variables
	//titre de l'action
	$scope.actionTitle = "prêts ? partez !";
	//Récupération du quiz
	$scope.quiz = $rootScope.quizStudent;
	// les différents types de question dans le quiz
	$scope.types = getTypes();
	//le mode des paramètres du quiz
	$scope.mode = getMode();
	//les différentes paramètres du quiz
	$scope.opts = getOpts();
	//récupère les différents type de médias
	$scope.medias = getMedias();
}]);
