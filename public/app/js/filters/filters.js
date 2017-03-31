'use strict';

/* Filters */
angular.module('quizsApp')
.filter('unique', [ function() {
	return function(items, filterOn) {
		if (filterOn !== false) {
			return _(items).uniq(filterOn);
		} else {
			return items;
		}
} }])
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
  	if (!input)
  		input = "";
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
		input = input*20/100;
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
}])
.filter('expire', [ function( ){
	return function(input){
		var cssClass = 'none';
		var today = new Date();
		input = new Date(input);
		var beforeEnd = Math.ceil((input.getTime()-today.getTime())/(1000*60*60*24));
		if (beforeEnd <= 3 && beforeEnd > 0){
			cssClass = 'warning';
		}
		if (Math.ceil((input.getTime()-today.getTime())/(1000*60*60*24)) == 0){
			cssClass = 'danger';
		}
		return cssClass;
	}
}]);
