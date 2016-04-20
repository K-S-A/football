'use strict'

angular.module('mainApp', [
  'ui.router'
  'ui.bootstrap'
  'ui.sortable'
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
        resolve: completedTournaments: ['Auth', 'Tournament', (Auth, Tournament) ->
          Auth.currentUser().then (user) ->
            Tournament.getUnrated(user.id)]
      .state 'assessment',
        url: '/assessments/{id:[0-9]+}'
        templateUrl: 'assessments/index.html'
        controller: 'AssessmentsCtrl as vm'
        resolve: tournamentAssessments: ['$stateParams', 'Auth', 'User', ($stateParams, Auth, User) ->
          Auth.currentUser().then (user) ->
            User.getParticipants($stateParams.id, user.id)]
      .state 'tournament',
        abstract: true
        url: '/tournaments/{id:[0-9]+}'
        templateUrl: 'tournaments/show.html'
        controller: 'TournamentsCtrl as vm'
        resolve: getCurrent: ['$stateParams', 'Tournament', 'Auth', ($stateParams, Tournament, Auth) ->
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
        resolve: getRounds: ['$stateParams', 'Round', 'Tournament', 'getCurrent',
          ($stateParams, Round, Tournament, getCurrent) ->
            Round.get(tournamentId: $stateParams.id).then (data) ->
              getCurrent.rounds = data]
      .state 'tournament.rounds.show',
        url: '/{round_id:[0-9]+}'
        templateUrl: 'rounds/show.html'
        resolve: getRound: ['$stateParams', 'Round', 'getCurrent',
          ($stateParams, Round, getCurrent) ->
            Round.get(tournamentId: $stateParams.id, id: $stateParams.round_id).then (data) ->
              Round.current = data]
      .state 'tournament.rounds.show.teams',
        url: '/teams'
        templateUrl: 'rounds/teams.html'
        controller: 'RoundsCtrl as vm'
      .state 'tournament.rounds.show.matches',
        url: '/matches'
        templateUrl: 'rounds/matches.html'
        controller: 'MatchesCtrl as vm'
        resolve: getMatches: ['$stateParams', 'Match',
          ($stateParams, Match) ->
            Match.get(roundId: $stateParams.round_id).then (data) ->
              Match.all = data]
      .state 'tournaments',
        url: '/tournaments'
        templateUrl: 'tournaments/index.html'
        controller: 'TournamentsCtrl as vm'
        resolve: getAll: ['Tournament', (Tournament) ->
          Tournament.current = {}
          Tournament.get().then (data) ->
            Tournament.all = data]

    $urlRouterProvider.otherwise '/tournaments'
    return

]).run([
  '$rootScope'
  '$state'
  'Auth'
  'auths'
  'editableOptions'
  'Tournament'
  'Round'
  ($rootScope, $state, Auth, auths, editableOptions, Tournament, Round) ->
    editableOptions.theme = 'bs3'

    $rootScope.$on("$stateChangeError", console.log.bind(console))

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams, options) ->
      event.preventDefault()

      switch toState.name
        when 'tournament.rounds'
          $state.go('tournament.rounds.show', {round_id: Tournament.current.rounds[0].id})
        when 'tournament.rounds.show'
          $state.go('tournament.rounds.show.teams')

    $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, options) ->
      switch toState.name
        when'tournament.rounds.show'
          event.preventDefault()
          Round.get(tournamentId: toParams.id).then (data) ->
            Tournament.current.rounds = data
            toParams.round_id = Tournament.current.rounds[0].id
            $state.go('tournament.rounds.show', toParams)
        when 'assessment'
          event.preventDefault()
          $state.go('profile')

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams, options) ->
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
