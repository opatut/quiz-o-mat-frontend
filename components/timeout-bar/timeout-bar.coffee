dateAdd = (date, interval, units) ->
    ret = new Date(date)
    switch interval.toLowerCase()
        when 'year'    then ret.setFullYear(ret.getFullYear() + units)
        when 'quarter' then ret.setMonth(ret.getMonth() + 3 * units)
        when 'month'   then ret.setMonth(ret.getMonth() + units)
        when 'week'    then ret.setDate(ret.getDate() + 7 * units)
        when 'day'     then ret.setDate(ret.getDate() + units)
        when 'hour'    then ret.setTime(ret.getTime() + units * 3600000)
        when 'minute'  then ret.setTime(ret.getTime() + units * 60000)
        when 'second'  then ret.setTime(ret.getTime() + units * 1000)
        else                ret = undefined
    return ret

Polymer {
    total: 12
    left: 12

    ready: ->
        @start()

    leftChanged: ->
        @start()

    start: ->
        if not @interval
            @interval = setInterval @tick.bind(@), 100

    stop: ->
        clearInterval @interval
        @interval = null

    tick: ->
        @left -= 0.1
        if @left < 0
            @left = 0
            @stop()
}
