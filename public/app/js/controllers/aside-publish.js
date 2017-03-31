'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('AsidePublishCtrl', ['$scope', '$state', '$stateParams', '$rootScope', '$timeout', 'APP_PATH', 'Notifications', 'Modal', 'PublicationsApi', 'QuizsApi', 'UsersApi', function($scope, $state, $stateParams, $rootScope, $timeout, APP_PATH, Notifications, Modal, PublicationsApi, QuizsApi, UsersApi) {
	QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		$scope.quiz = response.quiz_found;
		$scope.quiz.publishes = [];
		PublicationsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
			$scope.quiz.publishes = response.publications_found;
		});
	})
	UsersApi.regroupements({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
		if (!response.error) {
			if (response.regroupements_found.length == 0){
				Notifications.add("Vous n'avez aucun regroupement !", "warning");
			} else {
				$scope.regroupements = _.sortBy(response.regroupements_found, function(regroupement){
					return [regroupement.nameEtab, regroupement.name].join("_");
				});
				$rootScope.tmpPublishesRegroupements = angular.copy(_.where($scope.regroupements, {selected: true}));				
			}
		} else {
			Notifications.add("Impossible de récupérer vos regroupements !", "erreur");			
		};			
	});

	$scope.filters={
		showDate: false,
		modifDate: false,
	};


	$scope.reajouter = function(regroupement){
			$rootScope.tmpPublishesName = regroupement.name
			$rootScope.tmpPublishesRegroupements= [];
			$rootScope.tmpPublishesRegroupements.push(regroupement);
			regroupement.selected = true
	};
	
	//variable pour les datepickers
	$scope.fromDate = null;
	$scope.minDate = new Date(); 
	$scope.toDate = null;
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
  	//si on a des publications
  	$scope.index_publication=1;
  	if ($rootScope.tmpPublishesRegroupements.length > 0) {
  		//on copie dans une variable de fonction les publications
	  	var tmpPublishesRegroupements = angular.copy($rootScope.tmpPublishesRegroupements);
	  	//on vérifie si l'on a pas supprimé des publications
	  	_.each($scope.quiz.publishes, function(publish){
	  		//on recherche si la publication est toujours existante
	  		var tmpRegroupement = angular.copy(_.find(tmpPublishesRegroupements, function(tmpRgpt){
	  		 	return tmpRgpt.id === publish.rgptId
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
	  	
	  	PublicationsApi.modify({quiz_id: $stateParams.quiz_id, added: $rootScope.added, fromDate: $scope.fromDate, toDate: $scope.toDate, index_publication: $scope.index_publication}).$promise.then(function(response){
		QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		$scope.quiz = response.quiz_found;
		$scope.quiz.publishes = [];
		PublicationsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
			$scope.quiz.publishes = response.publications_found;
		});
	})
	});
  	};
}

 //républier un quiz
  $scope.republish = function(){

  	//si on a des publications
  if ($rootScope.tmpPublishesRegroupements!=null) {
  		//on copie dans une variable de fonction les publications
	  	var tmpPublishesRegroupements = angular.copy($rootScope.tmpPublishesRegroupements);
 			 var tmpindexpublication = 0;
 			 for (var i = 0; i < $scope.quiz.publishes.length; i++) {
  				  if ($scope.quiz.publishes[i].name == $rootScope.tmpPublishesName){
   					   if($scope.quiz.publishes[i].index_publication>tmpindexpublication){
   					   	tmpindexpublication=$scope.quiz.publishes[i].index_publication;
   					   }
  				  }
			  }
		 $scope.index_publication=tmpindexpublication+1;
	  	//on vérifie si l'on a pas supprimé des publications
	  	_.each($scope.quiz.publishes, function(publish){
	  		//on recherche si la publication est toujours existante
	  		var tmpRegroupement = angular.copy(_.find(tmpPublishesRegroupements, function(tmpRgpt){
	  		 	return tmpRgpt.id === publish.rgptId
	  		}));
	  	});
	  	//le reste c'est les ajout et ceux qui n'ont pas été modifié
	  	$rootScope.added = tmpPublishesRegroupements;
	  		PublicationsApi.modify({quiz_id: $stateParams.quiz_id, added: $rootScope.added, fromDate: $scope.fromDate, toDate: $scope.toDate, index_publication: $scope.index_publication}).$promise.then(function(response){
				QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		$scope.quiz = response.quiz_found;
		$scope.quiz.publishes = [];
		PublicationsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
			$scope.quiz.publishes = response.publications_found;
			});
		})
	});
};
}


  $scope.modifierDate = function(publication_id,fromDate,toDate){
	  	PublicationsApi.modifier({id: publication_id, fromDate: fromDate, toDate: toDate}).$promise.then(function(response){
		QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		$scope.quiz = response.quiz_found;
		$scope.quiz.publishes = [];
		PublicationsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
			$scope.quiz.publishes = response.publications_found;
		});
	})
});
}


    $scope.supprimer = function(id){
  	 $scope.index_publication=88;
  	//si on a des publications
  	if (id!=null) {
  		//on copie dans une variable de fonction les publications
	  	var tmpPublishesRegroupements = angular.copy($rootScope.tmpPublishesRegroupements);
	  	//on vérifie si l'on a pas supprimé des publications
	  	_.each($scope.quiz.publishes, function(publish){
	  		//on recherche si la publication est toujours existante
	  		var tmpRegroupement = angular.copy(_.find(tmpPublishesRegroupements, function(tmpRgpt){
	  		 	return tmpRgpt.id === id
	  		}));
	  		//si elle n'est plus, on l'enregistre dans les suppressions
	  		if (!tmpRegroupement) {
	  			$rootScope.deleted.push(publish);
	  		};
	  	});
	  	//le reste c'est les ajout et ceux qui n'ont pas été modifié
	  	$rootScope.added = tmpPublishesRegroupements;
	 PublicationsApi.delete({quiz_id: $stateParams.quiz_id, id: id, index_publication: $scope.index_publication}).$promise.then(function(response){
		QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		$scope.quiz = response.quiz_found;
		$scope.quiz.publishes = [];
		PublicationsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
			$scope.quiz.publishes = response.publications_found;
		
			});
		})
	});
  };
}

// duplique le quiz
	$scope.duplicatePublishQuiz = function(quiz_id,regroupement){
		 $scope.index_publication=1;
		QuizsApi.duplicate({id: quiz_id}).$promise.then(function(response){
			if (!response.error) {
				var quizDuplicated =  angular.copy(_.find($rootScope.quizs, function(quiz){
					return quiz.id === quiz_id;
				}));

	
				quizDuplicated.id = response.quiz_duplicated.id;
				quizDuplicated.share = false;
				quizDuplicated.publishes = tmpPublishesRegroupements;
				$rootScope.quizs.push(quizDuplicated);
				$rootScope.quizs.push(quizDuplicated);
				if ($rootScope.tmpPublishesRegroupements!=null) {
  					//on copie dans une variable de fonction les publications
	 		 	var tmpPublishesRegroupements = angular.copy($rootScope.tmpPublishesRegroupements);
	  				//on vérifie si l'on a pas supprimé des publications
	  			_.each($scope.quiz.publishes, function(publish){
	  			//on recherche si la publication est toujours existante
	  			var tmpRegroupement = angular.copy(_.find(tmpPublishesRegroupements, function(tmpRgpt){
	  		 	return tmpRgpt.id === publish.rgptId
		  		}));
		  	});
			  	//le reste c'est les ajout et ceux qui n'ont pas été modifié
			  	$rootScope.added = tmpPublishesRegroupements;
			  		PublicationsApi.modify({quiz_id: quizDuplicated.id, added: $rootScope.added, fromDate: $scope.fromDate, toDate: $scope.toDate, index_publication: $scope.index_publication}).$promise.then(function(response){
						QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
				$scope.quiz = response.quiz_found;
				$scope.quiz.publishes = [];
				PublicationsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
					$scope.quiz.publishes = response.publications_found;
						});
					})
				});
			
		  	};
		  	$state.go('quizs.publish', {quiz_id: quizDuplicated.id});
			};
		});
	}

	// Get the modal
var modal = document.getElementById('myModal');

// Get the button that opens the modal
var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal 
btn.onclick = function() {
    modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
    modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
	$scope.addPublish = function(){
		Modal.open($scope.modalAddPublishCtrl, APP_PATH+'/app/views/modals/add-publication.html', 'md');
	}

	
		//controller pour confirmer la suppression de publication avec une modal
		$scope.modalConfirmDeletedPubishCtrl = ["$scope", "$rootScope", "$uibModalInstance", "$state", "$stateParams", function($scope, $rootScope, $uibModalInstance, $state, $stateParams){
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
				$uibModalInstance.close();
			}
			$scope.ok = function(){
			
				PublicationsApi.supprimerPublication({quiz_id: $stateParams.quiz_id, id: id, index_publication: $scope.index_publication}).$promise.then(function(response){
				});
			}
		}];
}]);