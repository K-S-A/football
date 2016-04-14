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
      .state 'tournament',
        abstract: true
        url: '/tournaments/{id:[0-9]+}'
        templateUrl: 'tournaments/show.html'
        controller: 'TournamentsCtrl as vm'
        resolve: getCurrent: ['$stateParams', 'Tournament', ($stateParams, Tournament) ->
          Tournament.get($stateParams.id).then (data) ->
            Tournament.current = data]
      .state 'tournament.participants',
        url: '/participants'
        templateUrl: 'tournaments/participants.html'
      .state 'tournament.teams',
        url: '/teams'
        templateUrl: 'tournaments/teams.html'
      .state 'tournament.rounds',
        url: '/rounds'
        templateUrl: 'tournaments/rounds.html'
      .state 'tournament.rounds.show',
        url: '/{round_id:[0-9]+}'
        templateUrl: 'rounds/show.html'
        controller: 'RoundsCtrl as vm'
        resolve: getRound: ['$stateParams', 'Round', ($stateParams, Round) ->
          Round.findByTournament($stateParams.id, $stateParams.round_id).then (data) ->
            Round.current = data]
      .state 'tournaments',
        url: '/tournaments'
        templateUrl: 'tournaments/index.html'
        controller: 'TournamentsCtrl as vm'
        resolve: getAll: ['Tournament', (Tournament) ->
          Tournament.current = {}
          Tournament.get().then (data) ->
            Tournament.all = data]
#      .state 'team',
#        url: '/teams/{id:[0-9]+}'
#        templateUrl: 'teams/show.html'
#        controller: 'TeamsCtrl as vm'
#        resolve: getCurrent: ['$stateParams', 'Team', ($stateParams, Team) ->
#          Team.get($stateParams.id).then (data) ->
#            Team.current = data]

    $urlRouterProvider.otherwise '/tournaments'
    return

]).run([
  '$rootScope'
  '$state'
  'Auth'
  'auths'
  'editableOptions'
  'Tournament'
  ($rootScope, $state, Auth, auths, editableOptions, Tournament) ->
    editableOptions.theme = 'bs3'

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams, options) ->
      if toState.name is 'tournament.rounds'
        event.preventDefault()
        $state.go('tournament.rounds.show', {round_id: Tournament.current.rounds[0].id})

      Auth.currentUser()
      .then ->
        if ['login', 'register'].indexOf(toState.name) > -1
          event.preventDefault()
          $state.go 'tournaments'
      , (error) ->
        if ['profile'].indexOf(toState.name) > -1
          event.preventDefault()
          $state.go 'tournaments'
      return

    $rootScope.$on 'devise:login', (e, user) ->
      auths.setUser(user, 'You are authorized successfully.')
      return

    return
])
