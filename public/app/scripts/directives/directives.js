'use strict';

/* Filters */
angular.module('quizsApp')
.directive('ngShowClearLine', [ function( ){
	return {
		restrict: 'EA',
		link: function ($scope, element, attrs) {
      element.bind('click', function () {
      	var deleteLineElement = element[0].firstChild;
      	$('#'+deleteLineElement.id).toggleClass( "none" );
      });
    }
	}
}]);