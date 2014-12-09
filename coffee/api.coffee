Promise = require('es6-promise').Promise;

############################################################################################3

randomDelay = (callback) ->
    setTimeout callback, Math.random() * 1000 + 100

authHeader = "Token 2000"

apiCall = (url) ->
    Promise.resolve $.ajax {
        url: "http://localhost:5000" + url,
        dataType: "JSON",
        headers: {"Authorization": authHeader}
    }

############################################################################################3

exports.user =
    info: ->
        apiCall "/user/info"

    getInvites: ->
        new Promise (resolve, reject) ->
            randomDelay () ->
                resolve invites

exports.game =
    info: (game_id) ->
        apiCall "/game/#{game_id}/info"

    # Promise returns round data, without replies
    playRound: (game_id, round_index) ->
        apiCall "/game/#{game_id}/playRound/#{round_index}"

    # Promise returns new round data, with all replies, and the correct field in the answer
    answerRound: (game_id, round_index, answer_id) ->
        apiCall "/game/#{game_id}/answerRound/#{round_index}/#{answer_id}"
