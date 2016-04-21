'use strict'

angular.module('mainApp').factory 'Assessment', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    railsResourceFactory(
      url: 'tournament/{{tournamentId}}/assessments/{{id}}'
      name: 'assessment')

]
