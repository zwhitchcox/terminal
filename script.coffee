#'use strict';
cli = angular.module('cli',[])
#cli.controller('CLI', ['$scope','CLI',($scope,CLI) ->
    #play = (cmd,term) ->
      #if termCmd cmd,term
      #else if $scope.playing
        #if RegExp($scope.currentX.check).test(cmd)
          #term.echo($scope.currentX.output) if $scope.currentX.output != "" and $scope.currentX.output?
          #if !$scope.currentX.right
            #$scope.currentX.right = 1
          #else $scope.exercises.splice($scope.exercises.indexOf($scope.currentX), 1)
        #else
          #$scope.wrongs++
          #term.echo("[[;#f00;]#{$scope.currentX.sample}]")
        #$scope.play()
#
    #$scope.playing = false
    #$scope.prompt = '$ '
    #$scope.play = () ->
      #if $scope.exercises.length
        #before =$scope.currentX
        #if $scope.currentX? and $scope.currentX.next?
          #$scope.currentX = _.find($scope.exercises,
            #(ex) -> ex._id == $scope.currentX.next)
        #if !$scope.currentX? or $scope.currentX == before
          #$scope.currentX = getRandomExercise()
        #$scope.terminal.echo "[[;#fff;]#{$scope.currentX.challenge}]"
      #else
        #$scope.terminal.echo('Congratulations, you won!')
        #seconds = (Date.now()/1000-$scope.start)
        #$scope.terminal.echo("Time: "+Math.floor(seconds/60)+":" +(if (seconds<10) then '0' else '')+Math.floor(seconds %60))
        #window.user.modules[$scope.subject].push($scope.currentX.module)
        #setModule($scope.curIdx+1)
        #$scope.playing = false
#
    #getRandomExercise = () ->
      #while true
        #index = Math.floor(Math.random() * $scope.exercises.length)
        #if $scope.exercises.every((ex)->$scope.exercises[index]._id != ex.next)
          #break
      #return $scope.exercises[index]
    #$scope.stop = () ->
      #$scope.playing = false
      #$scope.paused = true
      #$scope.pauseTime = Date.now()/1000
#
    #subjectOptions =
      #"""
        #Please choose a subject:
#
         #01: Unix    (Mac/Linux)
         #02: MS DOS  (Windows)
         #03: git
#
      #"""
#
    #getSubject = (cmd) ->
      #switch parseInt cmd
        #when 1 then $scope.subject = 'unix'; $scope.prompt = '$ '
        #when 2 then $scope.subject = 'dos';  $scope.prompt = 'C:\\> '
        #when 3 then $scope.subject = 'git';  $scope.prompt = '$ '
        #else return $scope.terminal.echo subjectOptions
      #getExercises()
      #$scope.processCmd = play
#
    #$scope.greetings = subjectOptions
#
    #$scope.init = ->
      #$scope.processCmd = getSubject
#
    #setModule = (idx)->
      #if idx?
        #$scope.curModule = $.extend(true,{},$scope.modules[idx])
        #return setModule() if !$scope.curModule?
        #$scope.exercises = $scope.curModule.exercises
        #showModules(null,$scope.terminal)
        #$scope.numX = $scope.curModule.exercises.length
        #return
      #for module,i in $scope.modules
        #if !~window.user.modules[$scope.subject].indexOf(module.name)
          #$scope.curIdx = i
          #$scope.curModule = $.extend(true,{},module)
          #$scope.exercises = $scope.curModule.exercises
          #showModules(null,$scope.terminal)
          #$scope.numX = $scope.curModule.exercises.length
          #break
      #$scope.terminal.echo 'You have completed this subject.' if !$scope.curModule?
#
    #getExercises = ->
      #Exercises.query((modules) ->
        #console.log modules
        #$scope.modules = modules
        #$scope.terminal.echo """
            #Welcome to the #{$scope.subject} exercises.
            #Use 'help' to show commands, 'start' to begin.
          #"""
        #if !window.user.modules?
          #window.user.modules = {git:[],unix:[],dos:[]}
        #setModule()
      #)
#
    #termCmd = (userCmd,term) ->
      #for cmd of cmds
        #if cmds[cmd].test.test(userCmd)
          #cmds[cmd].action(userCmd,term)
          #return true
      #return false
    #showModules = (cmd,term)->
      #if $scope.modules?
        #$scope.modules.forEach((el,idx) ->
          #mod = (if idx < 10 then "0#{idx+1}" else idx+1) + ": #{el.name}"
          #if $scope.curModule.name == el.name
            #term.echo "[[;#00f;]#{mod}]"
          #else if ~window.user.modules[$scope.subject].indexOf(el.name)
            #term.echo "[[;#f00;]#{mod}]"
          #else term.echo mod
        #)
      #else term.echo 'You must set a module first!'
    #cmds =
      #help:
        #test: /^\s*help\s*$/g
        #action:(cmd,term)->
          #term.echo($scope.commands)
      #start:
        #test: /(^\s*start\s*$)|(^\s*st\s*$)/g
        #action: ->
          #if !$scope.paused
            #$scope.playing = true
            #$scope.start = Date.now()/1000
          #else
            #$scope.playing=true
            #$scope.paused=false
            #$scope.start = Date.now()/1000-$scope.start+$scope.pauseTime
          #$scope.play()
#
      #stop:
        #test: /^\s*stop\s*$/g
        #action: ->
          #$scope.stop()
      #modules:
        #test: /^\s*modules\s*$/g
        #action: showModules
      #change:
        #test:/^\s*cm\s*[0-9]+\s*$/g
        #action: (cmd,term) ->
          #setModule(parseInt(cmd.split(/\s+/)[1])-1)
#
#
    #$scope.commands =
      #"""
      #full                              Full screen
      #pfull                             Pretty full screen
      #start, st                         Begin exercises
      #pause                             Pause exercises
      #cm <module>                       Change module (by #)
      #modules                           Show modules
      #clear                             Clear screen
      #and that's about it...\n
#
      #Don't worry if you don't totally understand everything right away
#
      #"""
    #Array.prototype.getIndexBy = (name, value) ->
      #for prop,i in @
        #if (@[i][name] == value)
          #return i
#])
