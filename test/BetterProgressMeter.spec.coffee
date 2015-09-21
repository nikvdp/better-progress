$ = require "jquery"
BetterProgressMeter = require "../src/js/directives/betterProgress/BetterProgressMeter.coffee"

describe "BetterworksProgressMeter class", ->
  meter = new BetterProgressMeter()

  it "Should have a root element", ->
    expect(meter.rootEl).toBeTruthy()

  it "Should update the element's text to match actual progress", ->
    meter.updateProgress(.7, .9)
    expect(
      Number $(meter.rootEl).find('text').first().text()
    )
    .toEqual(.9*100)

  it "Should properly handle invalid progress values", ->
    meter.updateProgress(200.32, -10)
    expect(meter.expected).toEqual 1
    expect(meter.actual).toEqual 0

    meter.updateProgress('dog', NaN)
    expect(meter.actual).toEqual 0
    expect(meter.expected).toEqual 0

  it "Should change colors when expected and actual are more than 25% apart", ->
    meter.updateProgress(0, 0)
    initialColor = meter.color

    meter.updateProgress(0, .24)
    expect(initialColor).toEqual meter.color

    meter.updateProgress(0, .26)
    expect(initialColor).not.toEqual meter.color

    intermediateColor = meter.color
    meter.updateProgress(0, .49)
    expect(intermediateColor).toEqual meter.color
    meter.updateProgress(0, .51)
    expect(intermediateColor).not.toEqual meter.color




