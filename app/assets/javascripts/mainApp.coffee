'use strict'

angular.module('mainApp', [
  'ui.router'
  'ui.bootstrap'
  'templates'
  'Devise'
  'xeditable'
  'rails'
]).config([
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'home',
        url: '/home'
        templateUrl: 'home/home.html'
      .state 'login',
        url: '/login'
        templateUrl: 'auth/login.html'
        controller: 'AuthCtrl as vm'
      .state 'register',
        url: '/register'
        templateUrl: 'auth/register.html'
        controller: 'AuthCtrl as vm'
      .state 'profile',
        url: '/profile'
        templateUrl: 'auth/profile.html'
        controller: 'AuthCtrl as vm'
      .state 'tournaments',
        url: '/tournaments'
        templateUrl: 'tournaments/index.html'
        controller: 'TournamentsCtrl as vm'
        resolve: getAll: ['Tournament', (Tournament) ->
          Tournament.get().then (data) ->
            Tournament.all = data]

    $urlRouterProvider.otherwise '/home'
    return

]).run([
  '$rootScope'
  '$state'
  'Auth'
  'auths'
  'editableOptions'
  ($rootScope, $state, Auth, auths, editableOptions) ->
    editableOptions.theme = 'bs3'

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams, options) ->
      Auth.currentUser()
      .finally ->
        event.preventDefault()
      .then ->
        if ['login', 'register'].indexOf(toState.name) > -1
          $state.go 'home'
      , (error) ->
        if ['login', 'register', 'home'].indexOf(toState.name) < 0
          $state.go 'login'
      return

    $rootScope.$on 'devise:login', (e, user) ->
      auths.setUser(user, 'You are authorized successfully.')
      return

    return
])