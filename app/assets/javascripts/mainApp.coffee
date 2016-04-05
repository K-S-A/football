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

    $urlRouterProvider.otherwise '/home'
    return

]).run([
  '$rootScope'
  '$state'
  'Auth'
  'auths'
  ($rootScope, $state, Auth, auths) ->
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