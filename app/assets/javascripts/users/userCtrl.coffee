'use strict'

angular.module('mainApp').controller 'UserCtrl', [
  'Auth'
  'auths'
  'User'
  'Tournament'
  (Auth, auths, User, Tournament) ->
    vm = this

    vm.user = angular.extend(Auth._currentUser, User.current)
    vm.unratedTournaments = Tournament.unrated
    vm.tournaments = vm.user.tournaments.map (params) ->
      new Tournament(params)
    vm.tournament = teams: vm.user.teams

    vm.statuses = ['not started', 'in progress', 'completed']

    vm.update = (user) ->
      auths.updateUser(user)

    vm

]
