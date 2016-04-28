'use strict'

angular.module('mainApp').directive 'myDeleteMatch', [
  'Round'
  'Match'
  '$window'
  (Round, Match, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Remove match?')
          Match.$delete('/matches/' + scope.match.id).then (data) ->
            indexes = Match.all.map (match) ->
              match.id

            index = indexes.indexOf(scope.match.id)

            Match.all.splice(index, 1)

]
