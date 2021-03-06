'use strict'

angular.module('mainApp').directive 'myAddParticipants', [
  '$uibModal'
  'Tournament'
  ($uibModal, Tournament) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        modalInstance = $uibModal.open(
          templateUrl: 'tournaments/add_participants.html'
          controller: 'ParticipantsCtrl as vm'
          scope: scope
          size: 'lg'
          resolve: users: ['User', 'Tournament', (User, Tournament) ->
            User.get().then (data) ->
              # TODO - move to filter...
              users = []
              indexes = Tournament.current.users.map (obj) ->
                obj.id

              data.forEach (u) ->
                if indexes.indexOf(u.id) is -1
                  users.push(u)
              User.unsubscribed = users]
        )

        modalInstance.result.then (data) ->
          Tournament.current.users = data
          Tournament.current.update()

]
