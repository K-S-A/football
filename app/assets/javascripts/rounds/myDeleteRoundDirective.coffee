'use strict'

angular.module('mainApp').directive 'myDeleteRound', [
  'Round'
  'Tournament'
  '$stateParams'
  '$state'
  '$window'
  (Round, Tournament, $stateParams, $state, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', (e) ->
        e.stopPropagation()
        if $window.confirm('Remove round?')
          Round.$delete('/rounds/' + scope.round.id).then ->
            Round.get(tournamentId: $stateParams.id).then (data) ->
              Tournament.current.rounds = data
              switch
                when !data.length
                  $state.go('tournament.rounds')
                when parseInt($stateParams.round_id) is scope.round.id
                  $stateParams.round_id = data[0].id
                  $state.go('tournament.rounds.show', $stateParams)

]
