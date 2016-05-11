'use strict'

angular.module('mainApp').directive 'myIfState', [
  '$state'
  ($state) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch((-> $state.current.name), (newVal, oldVal) ->
        if newVal.indexOf(attrs.myIfState) > -1
          element.show()
        else
          element.hide())
]
