'use strict'

angular.module('mainApp').directive 'myAddPlayoffMatch', [
  'Round'
  'Match'
  (Round, Match) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.remove() if Round.current.mode == 'regular'

      scope.$watch 'match.children.length', (newVal, oldVal) ->
        element.hide() if newVal > 1

      element.on 'click', ->
        if scope.match
          new Match(nextId: scope.match.id, roundId: Round.current.id).create().then (data) ->
            scope.match.children ||= []
            scope.match.children.push(data)
        else
          new Match(nextId: null, roundId: Round.current.id).create().then (data) ->
            Match.all.push(data)
]
