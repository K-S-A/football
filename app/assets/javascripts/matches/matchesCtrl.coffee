'use strict'

angular.module('mainApp').controller 'MatchesCtrl', [
  'Match'
  'Round'
  'Team'
  (Match, Round, Team) ->
    vm = this

    vm.matches = Match.all
    vm.teams = Team.all
    vm.countRange = [1, 2, 3, 4, 5]
    vm.count = 1
    vm.viewModes = ['Table', 'List']
    vm.viewMode = vm.viewModes[0]

    if vm.teams.length > 1
      vm.match =
        roundId: Round.current.id
        hostTeamId: vm.teams[0].id
        guestTeamId: vm.teams[1].id

    vm.create = ->
      new Match(vm.match).create().then (data) ->
        vm.matches.unshift(data)

    vm.update = ->
      vm.editedMatch.roundId ||= Round.current.id
      vm.editedMatch.update()

    vm

]
