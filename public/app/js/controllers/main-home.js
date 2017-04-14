'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('MainHomeCtrl', ['$scope', '$state','$stateParams', '$rootScope', 'APP_PATH', 'Notifications', 'Modal', 'Users', 'QuizsApi','PublicationsApi', function($scope, $state, $stateParams, $rootScope, APP_PATH, Notifications, Modal, Users, QuizsApi,PublicationsApi) {

	// Si personnel education
	$scope.roleMax = Users.getCurrentUser().roleMaxPriority;
	$scope.parents = Users.getCurrentUser().isParents;
	$scope.user=Users.getCurrentUser;
	var today = new Date();
	// var aujourdhui = today.getDate();
	//on récupère les enfants du parents

	if ($scope.roleMax == 0 && $scope.parents) {
		//pour les parent fils courant
		QuizsApi.quizs().$promise.then(function(response){
			console.log("reponse.quizs_found")
			// console.log(reponse.quizs_found)
			$rootScope.quizs = response.quizs_found.quizs;
			$scope.childs = response.quizs_found.childs;
			$rootScope.currentChild = $scope.childs[0];
			$scope.quizs = angular.copy(_.filter($rootScope.quizs, function(quiz){
				return _.contains($scope.childs[0].quizs, quiz.id);
			}));
		});
	} else {
		QuizsApi.quizs().$promise.then(function(response){
			$rootScope.quizs = response.quizs_found;
		});
			PublicationsApi.getAllTut().$promise.then(function(response){
			$rootScope.users = response.publications_found;
		});
	};

	 $scope.filterFunction = function(element) {
		 return element.name.match(/^Ma/) ? true : false;
	  };

	$scope.changeCurrentChild = function(child){
		$rootScope.currentChild = child;
		$scope.quizs = angular.copy(_.filter($rootScope.quizs, function(quiz){
			return _.contains(child.quizs, quiz.id);
		}));
	}

	// ajoute un quiz et ouvre la création de ce quiz
	$scope.addQuiz = function(){
		QuizsApi.create().$promise.then(function(response){
			if (!response.error) {				
				$state.go('quizs.params', {quiz_id: response.quiz_created.id});
			} else {
				Notifications.add(response.error.msg, "error");
			};
		});
	}
	// ouvre la session du quiz pour ce regroupement
	$scope.openSession = function(quiz_id, rgpt_id){
		$state.go('quizs.sessions', {quiz_id: quiz_id, rgpt_id: rgpt_id});
	}

		$scope.openSessionPub = function(quiz_id, rgpt_id){
		$state.go('quizs.sessions-pub', {quiz_id: quiz_id, rgpt_id: rgpt_id});
	}

	// ouvre une modal avec tous les regroupements
	$scope.openRgpts = function(quiz_id){
		$rootScope.displayRgptsQuiz = _.find($rootScope.quizs, function(quiz){
			return quiz.id === quiz_id;
		});
		Modal.open($scope.modalDisplayRegroupementsCtrl, APP_PATH + '/app/views/modals/display-regroupements.html', 'md'); 
	}
	// joue le quiz
	$scope.playQuiz = function(quiz_id, publication_id){
		$state.go('quizs.start_quiz', {quiz_id: quiz_id,publication_id:publication_id});
	}
	// edit le quiz
	$scope.updateQuiz = function(quiz_id){
		$state.go('quizs.params', {quiz_id: quiz_id});
	}
	// supprime le quiz
	$scope.deleteQuiz = function(quiz_id){
		$rootScope.deleteQuizId = quiz_id;
		Modal.open($scope.modalClearQuizCtrl, APP_PATH + '/app/views/modals/confirm.html', 'md');
			 	$state.go('quizs.home');
	}
	// duplique le quiz
	$scope.duplicateQuiz = function(quiz_id){
		QuizsApi.duplicate({id: quiz_id}).$promise.then(function(response){
			if (!response.error) {
				var quizDuplicated =  angular.copy(_.find($rootScope.quizs, function(quiz){
					return quiz.id === quiz_id;
				}));
				quizDuplicated.id = response.quiz_duplicated.id;
				quizDuplicated.share = false;
				quizDuplicated.publishes = [];
				Modal.open($scope.modalNotifDupliquerQuizCtrl, APP_PATH + '/app/views/modals/notification.html', "md");
				$rootScope.quizs.push(quizDuplicated);
			};
		});
	}
	// publie le quiz
	$scope.publishQuiz = function(quiz_id){
		$state.go('quizs.publish', {quiz_id: quiz_id});
	}
	$scope.shared = function(quiz){
		QuizsApi.update({id: quiz.id, opt_shared: !quiz.share}).$promise.then(function(response){
			if (!response.error){
				angular.forEach($rootScope.quizs, function(q, index){
					if (q.id === quiz.id) {
						$rootScope.quizs[index].share = !quiz.share;						
					};
				});
			}
		})
	}

	$scope.filters={
		commence: false,
		encours: false,
		expiree: false,
	};
	
		$scope.changeDateExpiree = function(expiree){
		var today = new Date();
		$rootScope.users =[];
		if (expiree == true) {
				$scope.expiree = true;
					PublicationsApi.getAllTut().$promise.then(function(response){
						var iter= response.publications_found.length ;
							do{
								iter--;
								if(response.publications_found[iter].toDate!=null){
								var dateOne = (response.publications_found[iter].toDate);
								var annee = dateOne.split("-")[0];
								var mois = dateOne.split("-")[1];
								var jour = (dateOne.split("-")[2]).split(" ")[0];
								var hour = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[0];
								var minute = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[1];
								var seconde = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[2];
								var Zonehour = ((dateOne.split("-")[2]).split(" ")[2]).substring(0,3);
								var Zoneminute = ((dateOne.split("-")[2]).split(" ")[2]).substring(3,6);

								var dateTwo = annee+"-"+mois+"-"+jour+"T"+hour+":"+minute+":"+seconde+Zonehour+":"+Zoneminute
								var mydate = new Date(dateTwo);

								if (today>mydate){
								$rootScope.users.push(response.publications_found[iter]);
								}
							}
							}while(iter>0)
					});
		} else {
				$scope.commence = false;
				PublicationsApi.getAllTut().$promise.then(function(response){
			$rootScope.users = response.publications_found;
		});
		};
	};

	$scope.changeDateencours = function(encours){
		var today = new Date();
		$rootScope.users =[];
		if (encours == true) {
				$scope.encours = true;
					PublicationsApi.getAllTut().$promise.then(function(response){
						var iter= response.publications_found.length ;
							do{
								iter--;
								if(response.publications_found[iter].fromDate!=null){
								var dateOne = (response.publications_found[iter].fromDate);
								var annee = dateOne.split("-")[0];
								var mois = dateOne.split("-")[1];
								var jour = (dateOne.split("-")[2]).split(" ")[0];
								var hour = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[0];
								var minute = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[1];
								var seconde = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[2];
								var Zonehour = ((dateOne.split("-")[2]).split(" ")[2]).substring(0,3);
								var Zoneminute = ((dateOne.split("-")[2]).split(" ")[2]).substring(3,6);

								var dateTwo = annee+"-"+mois+"-"+jour+"T"+hour+":"+minute+":"+seconde+Zonehour+":"+Zoneminute
								var mydate = new Date(dateTwo);

								var dateFin = (response.publications_found[iter].toDate);
								var annee = dateFin.split("-")[0];
								var mois = dateFin.split("-")[1];
								var jour = (dateFin.split("-")[2]).split(" ")[0];
								var hour = ((dateFin.split("-")[2]).split(" ")[1]).split(":")[0];
								var minute = ((dateFin.split("-")[2]).split(" ")[1]).split(":")[1];
								var seconde = ((dateFin.split("-")[2]).split(" ")[1]).split(":")[2];
								var Zonehour = ((dateFin.split("-")[2]).split(" ")[2]).substring(0,3);
								var Zoneminute = ((dateFin.split("-")[2]).split(" ")[2]).substring(3,6);

								var dateTFin = annee+"-"+mois+"-"+jour+"T"+hour+":"+minute+":"+seconde+Zonehour+":"+Zoneminute
								var finDate = new Date(dateTFin); 
								if ((mydate<today)&&(today<finDate)){
								$rootScope.users.push(response.publications_found[iter]);
									}
							}
							else{
									$rootScope.users.push(response.publications_found[iter]);
							}
							}while(iter>0)
					});
		} else {
				$scope.commence = false;
				PublicationsApi.getAllTut().$promise.then(function(response){
			$rootScope.users = response.publications_found;
		});
		};
	};

	// retour vers la page d'accueil
			$scope.close = function(){
			$state.go('quizs.home');
			}

	$scope.changeDate = function(commence){
		var today = new Date();
		$rootScope.users =[];
		if (commence == true) {
				$scope.commence = true;
					PublicationsApi.getAllTut().$promise.then(function(response){
						var iter= response.publications_found.length ;
							do{
								iter--;
								if(response.publications_found[iter].fromDate!=null){
								var dateOne = (response.publications_found[iter].fromDate);
								var annee = dateOne.split("-")[0];
								var mois = dateOne.split("-")[1];
								var jour = (dateOne.split("-")[2]).split(" ")[0];
								var hour = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[0];
								var minute = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[1];
								var seconde = ((dateOne.split("-")[2]).split(" ")[1]).split(":")[2];
								var Zonehour = ((dateOne.split("-")[2]).split(" ")[2]).substring(0,3);
								var Zoneminute = ((dateOne.split("-")[2]).split(" ")[2]).substring(3,6);

								var dateTwo = annee+"-"+mois+"-"+jour+"T"+hour+":"+minute+":"+seconde+Zonehour+":"+Zoneminute
								var mydate = new Date(dateTwo);
								if (mydate>today){
								$rootScope.users.push(response.publications_found[iter]);
								}
							}
							}while(iter>0)
					});
		} else {
				$scope.commence = false;
				PublicationsApi.getAllTut().$promise.then(function(response){
			$rootScope.users = response.publications_found;
		});
		};
	};


	// -------------- Controllers Modal --------------- //
		$scope.modalNotifDupliquerQuizCtrl = ["$scope", "$rootScope", "$uibModalInstance", "$state", "$stateParams", function($scope, $rootScope, $uibModalInstance, $state, $stateParams){
			$scope.message = "Votre quiz a bien été dupliqué!";
		
				$scope.title = "dupliquer un quiz";
				// $scope.message += "Votre qui a été bien dupliquer";
		
			$scope.no = function(){
				$uibModalInstance.close();
			}
			$scope.ok = function(){
				$uibModalInstance.close();
			}
}];

		//controller pour afficher les regroupements dans lequel le quiz a été publié avec une modal
		$scope.modalDisplayRegroupementsCtrl = ["$scope", "$rootScope", "$uibModalInstance", function($scope, $rootScope, $uibModalInstance){
			$scope.rgpts = $rootScope.displayRgptsQuiz.publishes;
			$scope.close = function(){
				$rootScope.displayRgptsQuiz = {};
				$uibModalInstance.close();
			}
			$scope.openSession = function(rgpt_id){
				$uibModalInstance.close();
				$state.go('quizs.sessions', {quiz_id: $rootScope.displayRgptsQuiz.id, rgpt_id: rgpt_id});
			}
		}];

		//controller pour supprimer un quiz avec une modal
		$scope.modalClearQuizCtrl = ["$scope", "$rootScope", "$uibModalInstance", "QuizsApi", function($scope, $rootScope, $uibModalInstance, QuizsApi){
			$scope.title = "Supprimer un quiz";
			$scope.message = "Êtes vous sûr de vouloir supprimer ce quiz ?Attention Vous allez supprimer toutes les sessions et publications liées à ce quiz";
			$scope.no = function(){
				$uibModalInstance.close();
			}
			$scope.ok = function(){
				QuizsApi.delete({id: $rootScope.deleteQuizId}).$promise.then(function(response){
					if (!response.error) {
						$rootScope.quizs = _.reject($rootScope.quizs, function(quiz){
							return quiz.id === $rootScope.deleteQuizId;
						});
						$uibModalInstance.close();					
					};
				});			
			}
		}];
}]);
