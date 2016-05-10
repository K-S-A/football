'use strict'

angular.module('mainApp').directive 'myGenerateMatches', [
  'Match'
  'Round'
  '$window'
  (Match, Round, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Generate matches?')
          Match.generate(Round.current.id, scope.vm.count).then (data) ->
            data.forEach (match) ->
              scope.vm.matches.push(match)
]
