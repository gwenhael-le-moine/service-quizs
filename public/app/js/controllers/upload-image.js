'use strict';

/* Controllers */

angular.module('quizsApp')
quizsApp.controller('uploadImageCtrl', ['Upload', function(Upload){
  $scope.upload = function(files){
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      Upload.upload({
        url: APP_PATH + '/api/questions/create',
        method: 'POST',
        fields: {
          user_id: currentUserId
        },
        file: file,
        fileFormDataName: 'user_file[image]'
      });
    }
  };
}]);