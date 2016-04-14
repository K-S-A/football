'use strict'

angular.module('mainApp').factory 'Round', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Round = railsResourceFactory(
      url: '/rounds'
      name: 'round'
      serializer: railsSerializer ->
        @only 'id', 'mode', 'position')

    Round.findByTournament = (tournamentId, id) ->
      Round.$get('/tournaments/' + tournamentId + '/rounds/' + id)

    Round
]
