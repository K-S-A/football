'use strict'

angular.module('mainApp').directive 'myDeleteRound', [
  'Round'
  'Tournament'
  '$stateParams'
  '$state'
  (Round, Tournament, $stateParams, $state) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', (e) ->
        e.stopPropagation()
        Round.$delete('/rounds/' + scope.round.id).then ->
          Round.get(tournamentId: $stateParams.id).then (data) ->
            Tournament.current.rounds = data
            if parseInt($stateParams.round_id) is scope.round.id
              $stateParams.round_id = Tournament.current.rounds[0].id
              $state.go('tournament.rounds.show', $stateParams)
]
