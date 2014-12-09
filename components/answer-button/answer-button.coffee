Polymer {
    selected: false

    onClick: ->
        @selected = true
        @quizBox.onAnswerSelected @answer.id

    questionChanged: ->
        answer = @quizBox.getCurrentUserAnswer()
        @selected = answer && answer.id == @answer.id
}
