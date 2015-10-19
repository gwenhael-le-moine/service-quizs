'use strict';

/* Services */
angular.module('quizsApp')
.service('Erreur', [function() {
  this.message = function(code, messagePerso){
    if (messagePerso == null) {
      var message = "Une erreur s'est produite !";
      switch (code) {
        case '404':
          message = "Circulez, il n'y a rien à voir !!";
          break;
        case '401':
          message = "Vous n'êtes pas autorisé !!";
          break;
      }
    } else {
      message = messagePerso;
    };
    return message;
  };
}])
.service('State', [ function() {
  var scopeSave = null;
  var rootScopeSave = null;
  //sauvegarde du scope entier
  this.saveScope = function (scope) {
    scopeSave = scope;
  };
  //Retourne le scope
  this.restoreScope = function () {
    return scopeSave;
  };
  //sauvegarde du scope entier
  this.saveRootScope = function (rootScope) {
    rootScopeSave = rootScope;
  };
  //Retourne le scope
  this.restoreRootScope = function () {
    return rootScopeSave;
  };
}])
.service('Modal', ['$modal', 'APP_PATH', function($uibModal, APP_PATH) {
  //ouverture d'une modal personnalisable'
  this.open = function (controller, template, size) {

    var modalInstance = $uibModal.open({
      templateUrl: template,
      controller: controller,
      size: size
    });

    modalInstance.result.then(function () {
    });
  };
}])
.service('Line', ['$rootScope', '$compile', function($rootScope, $compile) {
  // Creation d'une ligne seulement avec un div et du CSS
  this.create = function (divId, lineId, x1, y1, x2, y2, scope) {
    //calcule de la longueur et de l'angle de la ligne
    var length = Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
    var angle  = Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
    //valeur css du transfor afin de dessiner la ligne
    var transform = 'rotate('+angle+'deg)';
    //comme l'icone suit le tracé de la ligne, on la remet droite.
    var transformClearLine = 'rotate('+-angle+'deg)';
    //afin que l'icone soit au milieu de la ligne, 
    //on l'insère a la moitié de la longueur de la ligne moins la moitié de la taille de l'icone
    var lengthClearLine = length/2-10 +"px"; 
    //injection de la ligne dans la page
    $('#'+divId).append($compile(angular.element('<div id="line'+lineId+'" ng-show-clear-line><p id="clearLine'+lineId+'" class="delete img none" ng-click="clearLine(\'line'+lineId+'\')"></p></div>'))(scope));       
    //ajout des classes css afin que la ligne ai l'aspect voulu
    $('#line'+lineId).addClass('line')
    .css({
      'position': 'absolute',
      'transform': transform,
    })
    .width(length)
    .offset({left: x1, top: y1});
    $('#clearLine'+lineId).css({
      'transform': transformClearLine,
      'left': lengthClearLine
    });
  };
  this.clear = function(id){
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
}]);

/************************************************************************************/
/*                   Resource to show flash messages and responses                  */
/************************************************************************************/
angular.module('services.messages', []); 
angular.module('services.messages').factory("Notifications", ['$rootScope', function($rootScope) {
  var indexSuccess = 0;
  var indexError = 0;
  var indexWarning = 0;
  var indexInfo = 0;
  $rootScope.notifications = {success: {}, error: {}, warning: {}, info: {}};
  return {
    add: function(message, classe) {
      /* classe success, error, warning, info*/
      switch(classe){
        case "success":
          $rootScope.notifications.success[indexSuccess++] = message;
          break;
        case "error":
          $rootScope.notifications.error[indexError++] = message;
          break;
        case "warning":
          $rootScope.notifications.warning[indexWarning++] = message;
          break;
        case "info":
          $rootScope.notifications.info[indexInfo++] = message;
          break;
      }
    },
    clear: function() {
      $rootScope.notifications = {success: {}, error: {}, warning: {}, info: {}};
    }
  }
}]);