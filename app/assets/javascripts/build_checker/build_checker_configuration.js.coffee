class @BuildCheckerConfiguration
  @concurrentBuilds: (value) ->
    $.post 'build_checkers/concurrent_builds',  {value: value}
      .done (result) ->
        document.querySelector('input[name=serverConcurrentBuilds]').value = result.serverValue
      .fail (result) ->
        serverValue = document.querySelector('input[name=serverConcurrentBuilds]').value
        document.querySelector('input[name=concurrentBuilds]').value = serverValue
        document.getElementById('concurrentBuildsValue').innerText = serverValue

  @queueSize: (value) ->
    $.post 'build_checkers/queue_size',  {value: value}
      .done (result) ->
        document.querySelector('input[name=serverQueueSize]').value = result.serverValue
      .fail (result) ->
        serverValue = document.querySelector('input[name=serverQueueSize]').value
        document.querySelector('input[name=queueSize]').value = serverValue
        document.getElementById('queueSizeValue').innerText = serverValue