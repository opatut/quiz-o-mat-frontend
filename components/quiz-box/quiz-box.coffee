api = require('../../coffee/api.coffee')

Polymer {
    gameId: 0
    roundIndex: -1
    game: null
    user: null
    round: null
    rounds: []
    busy: false
    busyStack: 0

    # Status can be either of the following and cycles around in order:
    # - loading: Round is loading (busy)
    # - playing: Time is running out for the user to make a choice
    # - replying: Answer is being sent to server (busy)
    # - showing: Correct answer is being shown
    status: "loading"

    ready: ->
        @busify api.user.info()
        .then (user) =>
            @user = user

    roundIndexChanged: (_, index) ->
        @status = "loading"
        if index of @rounds and @rounds[index]
            @round = @rounds[index]
        else
            @busify api.game.playRound @gameId, index
            .then (round) =>
                @putRound index, round
                @round = round

    roundChanged: ->
        @status = "playing"
        @$.timeout.total = 12
        @$.timeout.left = 12

    gameIdChanged: (_, id) ->
        @busify api.game.info id
        .then (game) =>
            @game = game

    gameChanged: (_, game) ->
        @roundIndex = 0
        @rounds[i] = null for i in [0...@game.round_count]

    nextRound: ->
        @roundIndex++ if @roundIndex < @game.round_count - 1

    prevRound: ->
        @roundIndex-- if @roundIndex > 0

    putRound: (index, round) ->
        @rounds[index] = round unless index of @rounds and @rounds[index]

    updateRound: (index, round) ->
        @rounds[index].question.correct_answer_id = round.question.correct_answer_id
        @rounds[index].replies = round.replies

    busyStackChanged: ->
        @busy = @busyStack > 0

    busify: (promise) ->
        @busyStack++
        promise.then =>
            @busyStack--
        promise.catch (error) =>
            @busyStack--
            console.log "Caught error: ", error
        return promise

    onAnswerSelected: (answer_id) ->
        @status = "replying"
        @busify api.game.answerRound @gameId, @roundIndex, answer_id
        .then (round) =>
            @status = "showing"
            @updateRound @roundIndex, round
            @round = @rounds[@roundIndex]

    getCurrentUserAnswer: ->
        if not @round or not @round.replies
            return null
        replies = @round.replies.filter (x) =>
            x.player_id == @user.id
        answers = @round.question.all_answers.filter (x) ->
            x.id == replies[0].answer_id
        return answers[0]

}
