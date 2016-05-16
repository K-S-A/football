'use strict'

angular.module('mainApp', [
  'ui.router'
  'ui.bootstrap'
  'ui.sortable'
  'templates'
  'Devise'
  'xeditable'
  'infinite-scroll'
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
        controller: 'UserCtrl as vm'
        resolve: completedTournaments: ['Auth', 'Tournament', 'User', (Auth, Tournament, User) ->
          Auth.currentUser().then (user) ->
            Tournament.getUnrated(user.id).then ->
              User.get(id: user.id).then (data) ->
                User.current = data]
      .state 'tournament.assessment',
        url: '/assessments'
        templateUrl: 'tournaments/assessments.html'
        controller: 'AssessmentsCtrl as vm'
        resolve: tournamentAssessments: ['$q', 'getTournament', 'Auth', 'User', ($q, getTournament, Auth, User) ->
          defered = $q.defer()
          if getTournament.status == 'completed'
            defered.resolve()
          else
            defered.reject('wrong tournament status')

          defered.promise.then ->
            Auth.currentUser().then (user) ->
              User.getParticipants(getTournament.id, user.id)]
      .state 'tournament',
        abstract: true
        url: '/tournaments/{id:[0-9]+}'
        template: '<ui-view></ui-view>'
        controller: 'TournamentsCtrl as vm'
        resolve: getTournament: ['$stateParams', 'Tournament', 'Auth', ($stateParams, Tournament, Auth) ->
          Tournament.get($stateParams.id).then (data) ->
            Tournament.current = data]
      .state 'tournament.participants',
        url: '/participants'
        templateUrl: 'tournaments/participants.html'
      .state 'tournament.teams',
        url: '/teams'
        templateUrl: 'tournaments/teams.html'
        resolve: getTeams: ['$stateParams', 'Team', 'getTournament',
          ($stateParams, Team, getTournament) ->
            Team.$get('/tournaments/' + $stateParams.id + '/teams').then (data) ->
              getTournament.teams = data]
      .state 'tournament.rounds',
        url: '/rounds'
        templateUrl: 'tournaments/rounds.html'
        controller: 'RoundsCtrl as vm'
        resolve: getRounds: ['$stateParams', 'Round', 'Tournament', 'getTournament',
          ($stateParams, Round, Tournament, getTournament) ->
            Round.get(tournamentId: $stateParams.id).then (data) ->
              getTournament.rounds = data]
      .state 'tournament.rounds.show',
        url: '/{round_id:[0-9]+}'
        templateUrl: 'rounds/show.html'
        resolve: getRound: ['$stateParams', 'Round', 'getTournament',
          ($stateParams, Round, getTournament) ->
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
        resolve: getMatches: ['$stateParams', 'getRound', 'Match', 'Team',
          ($stateParams, getRound, Match, Team) ->
            Match.get(roundId: $stateParams.round_id).then (data) ->
              if getRound.mode == 'regular'
                Match.all = data
              else
                Match.all = Match.toTree(data)
            Team.$get('/rounds/' + $stateParams.round_id + '/teams').then (data) ->
              Team.all = data]
      .state 'tournaments',
        url: '/tournaments'
        templateUrl: 'tournaments/index.html'
        controller: 'TournamentsCtrl as vm'
        resolve: getAll: ['Tournament', (Tournament) ->
          Tournament.current = {}
          Tournament.get().then (data) ->
            Tournament.all = data]
      .state 'team',
        url: '/teams/{id:[0-9]+}'
        templateUrl: 'teams/show.html'
        controller: 'TeamsCtrl as vm'
        resolve: getTeam: ['Team', '$stateParams', (Team, $stateParams) ->
          Team.get(id: $stateParams.id).then (data) ->
            Team.current = data]
      .state 'user',
        url: '/users/{id:[0-9]+}'
        templateUrl: 'users/show.html'
        controller: 'UsersCtrl as vm'
        resolve: getUser: ['User', '$stateParams', (User, $stateParams) ->
          User.get(id: $stateParams.id).then (data) ->
            User.current = data]

    $urlRouterProvider.otherwise '/tournaments'
    return

]).run([
  '$rootScope'
  '$state'
  '$window'
  'Auth'
  'auths'
  'editableOptions'
  'Tournament'
  'Round'
  ($rootScope, $state, $window, Auth, auths, editableOptions, Tournament, Round) ->
    editableOptions.theme = 'bs3'

    $rootScope.$on("$stateChangeError", console.log.bind(console))

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams, options) ->
      event.preventDefault()

      switch toState.name
        when 'tournament.rounds'
          round = Tournament.current.rounds[0]
          if round
            $state.go('tournament.rounds.show', {round_id: round.id})
        when 'tournament.rounds.show'
          $state.go('tournament.rounds.show.teams')

    $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, options) ->
      switch toState.name
        when'tournament.rounds.show'
          Round.get(tournamentId: toParams.id).then (data) ->
            Tournament.current.rounds = data
            if data.length
              event.preventDefault()
              toParams.round_id = Tournament.current.rounds[0].id
              $state.go('tournament.rounds.show', toParams)
        when 'tournament.assessment'
          event.preventDefault()
          $state.go('profile')
        else
          $state.go('tournaments')

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

    # Facebook SDK
    $window.fbAsyncInit = ->
      FB.init
        appId: '1534051593567666'
        cookie: true
        xfbml: true
        version: 'v2.5'

      auths.watchLoginChange()
      return

    ((d, s, id) ->
      js = undefined
      fjs = d.getElementsByTagName(s)[0]
      if d.getElementById(id)
        return
      js = d.createElement(s)
      js.id = id
      js.src = '//connect.facebook.net/en_US/sdk.js'
      fjs.parentNode.insertBefore js, fjs
      return
    ) document, 'script', 'facebook-jssdk'

    # VK SDK
    #$window.vkAsyncInit = ->
    #  VK.init
    #    apiId: '5450208'
    #    scope: 'email'
    #    redirect_uri: 'http://localhost:3000/users/auth/vkontakte/callback'
    #    response_type: 'code'

    #  VK.UI.button('vk-login-button')
    #  auths.watchVkLoginChange()

    #((d, s, id) ->
    #  js = undefined
    #  fjs = d.getElementsByTagName(s)[0]
    #  if d.getElementById(id)
    #    return
    #  js = d.createElement(s)
    #  js.id = id
    #  js.src = '//vk.com/js/api/openapi.js'
    #  fjs.parentNode.insertBefore js, fjs
    #  return
    #) document, 'script', 'vk-jssdk'

    return
])

angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 1000)
