'use strict'

angular.module('mainApp').factory 'Assessment', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    railsResourceFactory(
      url: 'tournaments/{{tournamentId}}/assessments/{{id}}'
      name: 'assesment'
      serializer: railsSerializer ->
        # TODO: possible issues
        @only 'score', 'userId', 'ratedUserId')

]
