// Generated by CoffeeScript 1.9.3
(function() {
  'use strict';
  var cli;

  cli = angular.module('cli', ['ngResource']);

  cli.controller('Ctrl', [
    '$scope', '$http', 'Exercises', function($scope, $http, Exercises) {
      var cmds, getRandomExercise, getSubject, play, play2, setModule, showModules, subjectOptions, termCmd;
      $scope.init = function() {
        $scope.processCmd = getSubject;
        return $http.get('cli.json').success(function(data) {
          $scope.subjects = data;
          return console.log(data);
        });
      };
      subjectOptions = "Please enter a number to choose a subject:\n\n 1: Unix    (Mac/Linux)\n 2: MS DOS  (Windows)\n 3: Git\n\n Use 'help' to show the help\n";
      getSubject = function(cmd) {
        switch (parseInt(cmd)) {
          case 1:
            $scope.subject = 'Unix';
            $scope.terminal.set_prompt('$ ');
            break;
          case 2:
            $scope.subject = 'DOS';
            $scope.terminal.set_prompt('C:\\> ');
            break;
          case 3:
            $scope.subject = 'Git';
            $scope.terminal.set_prompt('$ ');
            break;
          case 4:
            $scope.subject = 'Python';
            $scope.terminal.set_prompt('>>> ');
            break;
          default:
            return $scope.terminal.echo(subjectOptions);
        }
        $scope.modules = Object.keys($scope.subjects[$scope.subject]);
        $scope.terminal.echo("Please choose a module to continue");
        $scope.modules.forEach(function(cur, i) {
          return $scope.terminal.echo(i + ': ' + cur);
        });
        return $scope.processCmd = setModule;
      };
      $scope.greetings = subjectOptions;
      $scope.playing = false;
      $scope.prompt = '$ ';
      setModule = function(idx) {
        try {
          idx = parseInt(idx);
          if (idx + 1 > $scope.modules.length) {
            idx = 0;
          }
          $scope.curIdx = idx;
          if ($scope.modules[idx] !== void 0) {
            $scope.terminal.echo("[[;#00f;]" + $scope.modules[idx] + "]");
            $scope.exercises = $scope.subjects[$scope.subject][$scope.modules[idx]].reduce(function(prev, cur) {
              prev.push($.extend(true, {}, cur));
              return prev;
            }, []);
            $scope.numX = $scope.exercises.length;
            $scope.processCmd = play;
            $scope.currentx = getRandomExercise();
          }
          return play2();
        } catch (_error) {
          return $scope.terminal.echo('Please input the number of the module you choose');
        }
      };
      getRandomExercise = function() {
        return $scope.exercises[Math.floor(Math.random() * $scope.exercises.length)];
      };
      play = function(cmd, term) {
        if (!termCmd(cmd, term && $scope.playing)) {
          if (RegExp($scope.currentX.check).test(cmd)) {
            if ($scope.currentX.output !== "" && ($scope.currentX.output != null)) {
              term.echo($scope.currentX.output);
            }
            if (!$scope.currentX.right) {
              $scope.currentX.right = 1;
            } else {
              $scope.exercises.splice($scope.exercises.indexOf($scope.currentX), 1);
            }
          } else {
            $scope.wrongs++;
            term.echo("[[;#f00;]" + ($.terminal.escape_brackets($scope.currentX.sample)) + "]");
          }
          return play2();
        }
      };
      play2 = function() {
        var before;
        if ($scope.exercises.length) {
          before = $scope.currentX;
          if (($scope.currentX != null) && ($scope.currentX.next != null)) {
            $scope.currentX = _.find($scope.exercises, function(ex) {
              return ex.id === $scope.currentX.next;
            });
          }
          if (($scope.currentX == null) || $scope.currentX === before) {
            $scope.currentX = getRandomExercise();
          }
          return $scope.terminal.echo("[[;#fff;]" + $scope.currentX.challenge + "]");
        } else {
          $scope.terminal.echo("[[;#00f;]" + $scope.curIdx + ": " + $scope.modules[$scope.curIdx] + " Complete.\nGreat Job!]");
          setModule($scope.curIdx + 1);
          return $scope.playing = false;
        }
      };
      termCmd = function(userCmd, term) {
        var cmd;
        for (cmd in cmds) {
          if (cmds[cmd].test.test(userCmd)) {
            cmds[cmd].action(userCmd, term);
            return true;
          }
        }
        return false;
      };
      showModules = function(cmd, term) {
        if ($scope.modules != null) {
          return $scope.modules.forEach(function(el, idx) {
            if ($scope.curIdx !== idx) {
              return $scope.terminal.echo(idx + ": " + el);
            }
            return $scope.terminal.echo("[[;#00f;]" + idx + ": " + el + "]");
          });
        } else {
          return $scope.terminal.echo('You must set a subject first!');
        }
      };
      cmds = {
        help: {
          test: /^\s*help\s*$/g,
          action: function(cmd, term) {
            return $scope.terminal.echo($scope.commands);
          }
        },
        modules: {
          test: /^\s*modules\s*$/g,
          action: showModules
        },
        change: {
          test: /^\s*cm\s*[0-9]+\s*$/g,
          action: function(cmd, term) {
            return setModule(parseInt(cmd.split(/\s+/)[1]));
          }
        }
      };
      return $scope.commands = "full                              Full screen\npfull                             Pretty full screen\ncm <module number>                Change module (by #)\nmodules                           Show modules\n\ntip: use Shift+Enter to enter multi-line statements\n\nGot a better way to do something, or want to change \nsomething about this project?\nSubmit a pull request or report an issue!\nhttp://github.com/zwhitchchcox/terminal\n";
    }
  ]);

}).call(this);
