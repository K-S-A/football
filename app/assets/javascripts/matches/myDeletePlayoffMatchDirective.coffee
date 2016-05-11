'use strict'

angular.module('mainApp').directive 'myDeletePlayoffMatch', [
  'Round'
  'Match'
  '$window'
  (Round, Match, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Remove match?')
          Match.$delete('/matches/' + scope.match.id).then (data) ->
            if scope.$parent.$parent.match
              indexes = Match.all.map (match) ->
                match.id

              index = indexes.indexOf(scope.match.id)
              scope.$parent.$parent.match.children.splice(scope.$index, 1)
            else
              scope.vm.matches.splice(scope.$index, 1)

]
