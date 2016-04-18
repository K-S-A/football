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
              Match.all.splice(scope.$index, 1)
]
