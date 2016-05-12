'use strict'

angular.module('mainApp').directive 'myChildStateLink', [
  '$state'
  ($state) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch (-> $state.current.name), (newVal, oldVal) ->
        if $state.$current.url.segments.length == 2
          name = if $state.current.url == '/participants' then 'Participants' else 'Teams'
        else
          name = 'Rounds'
        element.html(name + '<span class="caret"></span>')
]
