'use strict';

/* Filters */
angular.module('quizsApp')
.filter('overflow', [ function( ){
	return function(input){
		if (input && input.length > 30) {
			var words = input.split(" ");
			var tmp = "";
			var i = 0;
			while (tmp.length < 27){
				tmp += words[i++]+" ";
				if (tmp.length < 27) {
					input = tmp.substring(0, tmp.length-1);			
				};
			}
			input += "...";
		};
		return input;
	}
}])
.filter('acronym', [ function( ){
	return function(input){
		if (input) {
			switch(input){
				case "qcm":
					return "QCM";
					break;
				case "tat":
				 return "Texte à trous";
				 break;
				case "ass":
					return "Association";
					break;
			}
		};
		return input;
	}
}]);