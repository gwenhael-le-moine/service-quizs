'use strict';

// Declare app level module which depends on filters, and services
angular.module('quizsApp', [ 'ui.router',
                             'ngResource',
                             'ui.bootstrap',
                             'ui.sortable',
                             'as.sortable',
                             'ngFileUpload',
                             'services.messages',
                             'growlNotifications' ] )
    .run( [ '$rootScope', '$location', 'Notifications', 'Users',
            function( $rootScope, $location, Notifications, Users ) {
                Notifications.clear();
                //initialisation des données
                //id temp à effacer pour la BO
                $rootScope.tmpId = 0;
                $rootScope.$on( '$stateChangeStart',
                                function( $location ) {
                                    Notifications.clear();
                                } );
                window.scope = $rootScope;
            } ] );
