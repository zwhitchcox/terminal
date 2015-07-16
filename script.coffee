'use strict';
cli = angular.module('cli',['ngResource'])
cli.controller('Ctrl', ['$scope','$http','Exercises',($scope,$http,Exercises) ->
  $scope.init = ->
    console.log 'initialized'
    $scope.processCmd = getSubject

    $http.get('/cli.json')
      .success((data)->
        $scope.subjects = data
        console.log data
      )
  subjectOptions =
    """
      Please enter a number to choose a subject:

       1: Unix    (Mac/Linux)
       2: MS DOS  (Windows)
       3: Git

       Use 'help' to show the help

    """
  getSubject = (cmd) ->
    switch parseInt cmd
      when 1 then $scope.subject = 'Unix';    $scope.terminal.set_prompt '$ '
      when 2 then $scope.subject = 'DOS';     $scope.terminal.set_prompt 'C:\\> '
      when 3 then $scope.subject = 'Git';     $scope.terminal.set_prompt '$ '
      when 4 then $scope.subject = 'Python';  $scope.terminal.set_prompt '>>> '
      else return $scope.terminal.echo subjectOptions
    $scope.modules = Object.keys($scope.subjects[$scope.subject])
    $scope.terminal.echo "Please choose a module to continue"
    $scope.modules.forEach((cur,i) ->
      $scope.terminal.echo i+': '+cur
    )
    $scope.processCmd = setModule
  $scope.greetings = subjectOptions
  $scope.playing = false
  $scope.prompt = '$ '
  setModule = (idx)->
    try
      idx = parseInt(idx)
      idx = 0 if (idx+1>$scope.modules.length)
      $scope.curIdx = idx
      if $scope.modules[idx] != undefined
        $scope.terminal.echo "[[;#00f;]"+$scope.modules[idx]+"]"
        $scope.exercises = $scope.subjects[$scope.subject][$scope.modules[idx]].reduce((prev,cur) ->
          prev.push($.extend(true,{},cur))
          return prev
        ,[])
        $scope.numX = $scope.exercises.length
        $scope.processCmd=play
        $scope.currentx = getRandomExercise()
      play2()
    catch
      $scope.terminal.echo 'Please input the number of the module you choose'
  getRandomExercise = () ->
    return $scope.exercises[Math.floor(Math.random()*$scope.exercises.length)]

  play = (cmd,term) ->
    if !termCmd cmd,term && $scope.playing
      if RegExp($scope.currentX.check).test(cmd)
        term.echo($scope.currentX.output) if $scope.currentX.output != "" and $scope.currentX.output?
        if !$scope.currentX.right
          $scope.currentX.right = 1
        else $scope.exercises.splice($scope.exercises.indexOf($scope.currentX), 1)
      else
        $scope.wrongs++
        term.echo("[[;#f00;]#{$.terminal.escape_brackets($scope.currentX.sample)}]")
      play2()

  play2 = () ->
    if $scope.exercises.length
      before =$scope.currentX
      if $scope.currentX? and $scope.currentX.next?
        $scope.currentX = _.find($scope.exercises,
          (ex) -> ex.id == $scope.currentX.next)
      if !$scope.currentX? or $scope.currentX == before
        $scope.currentX = getRandomExercise()
      $scope.terminal.echo "[[;#fff;]#{$scope.currentX.challenge}]"
    else
      $scope.terminal.echo("[[;#00f;]"+$scope.curIdx+": "+$scope.modules[$scope.curIdx]+" Complete.\nGreat Job!]")
      setModule($scope.curIdx+1)
      $scope.playing = false
      
  termCmd = (userCmd,term) ->
    for cmd of cmds
      if cmds[cmd].test.test(userCmd)
        cmds[cmd].action(userCmd,term)
        return true
    return false
    
  showModules = (cmd,term)->
    if $scope.modules?
      $scope.modules.forEach((el,idx) ->
        return $scope.terminal.echo "#{idx}: #{el}" if $scope.curIdx != idx
        $scope.terminal.echo "[[;#00f;]#{idx}: #{el}]"
        
      )
    else $scope.terminal.echo 'You must set a subject first!'
    
  cmds =
    help:
      test: /^\s*help\s*$/g
      action:(cmd,term)->
        $scope.terminal.echo($scope.commands)
    modules:
      test: /^\s*modules\s*$/g
      action: showModules
    change:
      test:/^\s*cm\s*[0-9]+\s*$/g
      action: (cmd,term) ->
        setModule(parseInt(cmd.split(/\s+/)[1]))


  $scope.commands =
    """
    full                              Full screen
    pfull                             Pretty full screen
    cm <module number>                Change module (by #)
    modules                           Show modules
    
    tip: use Shift+Enter to enter multi-line statements

    Got a better way to do something, or want to change 
    something about this project?
    Submit a pull request or report an issue!
    http://github.com/zwhitchchcox/terminal

    """
])
