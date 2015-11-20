'use strict';

/* Filters */
angular.module('quizsApp')
.filter('placeholder', [ function( ){
	return function(input){
		if (!input || input == "") {
			return "insérez un titre pour votre quiz";
		};
		return input;
	}
}])
.filter('overflow', [ function( ){
	return function(input, lengthMax){
		if (input && input.length > lengthMax) {
			var words = input.split(" ");
			var tmp = "";
			var i = 0;
			while (words.length > i && tmp.length < lengthMax-3){
				tmp += words[i++]+" ";
				if (tmp.length <= lengthMax-3) {
					input = tmp.substring(0, tmp.length-1);
				} else {
					input = tmp.substring(0, lengthMax-3);
				};
			}
			input += "...";
		};
		return input;
	}
}])
.filter('capitalize', [ function() {
  return function(input, all) {
  	var capitalized = "";
  	if (all) {
  		capitalized = input.replace(/(?:^|\s)\S/g, function(a){ return a.toUpperCase();});
  	} else {
    	capitalized = input.charAt(0).toUpperCase() + input.slice(1);  		
  	};
  	return capitalized;
  }
}])
.filter('acronym', [ function( ){
	return function(input){
		if (input) {
			switch(input.toLowerCase()){
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
}])
.filter('scorecss', [ function( ){
	return function(input){
		var scoreCss = "00";
		var scoreRound = Math.round(input);
		if (scoreRound % 2 !== 0){
			if (input >= scoreRound) {
				scoreRound++;
			} else {
				scoreRound--;
			};
		}
		scoreCss = scoreRound.toString();
		if (scoreRound < 10)
			scoreCss = "0"+scoreCss;
		return scoreCss;
	}
}]);