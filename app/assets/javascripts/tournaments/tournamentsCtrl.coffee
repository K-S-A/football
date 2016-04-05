'use strict'

angular.module('mainApp').controller 'TournamentsCtrl', [
  'Tournament'
  (Tournament) ->
    vm = this

    vm.tournaments = Tournament.all

    vm.create = ->
      new Tournament(vm.tournament).create().then (data) ->
        vm.tournaments.push(data)
        vm.tournament = {}

    vm
]