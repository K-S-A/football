'use strict'

angular.module('mainApp').directive 'myLoading', [
  'Tournament'
  '$timeout'
  (Tournament, $timeout) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch (->Tournament.loading), (newVal) ->
        console.log(newVal)
        if newVal
          element.show()
          $timeout ->
            Tournament.loading = false
          , 1500
        else
          element.hide()
]
