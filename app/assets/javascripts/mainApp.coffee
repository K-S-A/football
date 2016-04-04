'use strict'

angular.module('mainApp', [
  'ui.router'
  'ui.bootstrap'
  'templates'
  'Devise'
  'rails'
]).config([
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'home',
        url: '/home'
        templateUrl: 'home/home.html'

    $urlRouterProvider.otherwise '/home'
    return

])