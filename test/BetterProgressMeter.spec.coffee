BetterProgressMeter = require "../src/js/directives/betterProgress/BetterProgressMeter.coffee"

describe "BetterworksProgressMeter class", ->
  meter = new BetterProgressMeter()
  it "Should have a root Element", ->
    expect(meter.rootEl).toBeTruthy()
