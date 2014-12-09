Polymer {
    roundIndex: 0
    roundCount: 18
    rounds: []
    iterator: [0...18]

    roundCountChanged: ->
        @iterator = [0...@roundCount]
}
