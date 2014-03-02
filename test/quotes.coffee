
###
Test CSV - Copyright David Worms <open@adaltas.com> (BSD Licensed)
###

fs = require 'fs'
should = require 'should'
csv = if process.env.CSV_COV then require '../lib-cov' else require '../src'

describe 'quotes', ->

  describe 'error', ->
    
    it 'when invalid quotes', (next) ->
      csv()
      .from.string("""
        ""  1974    8.8392926E7 ""t ""
        ""  1974    8.8392926E7 ""  ""
        """, quote: '"', escape: '"', delimiter: "\t")
      .on 'close', ->
        false.should.be.ok
      .on 'error', (e) ->
        e.message.should.eql 'Invalid closing quote at line 1; found " " instead of delimiter "\\t"'
        next()
    
    it 'when invalid quotes from string', (next) ->
      csv()
      .from.string '"",1974,8.8392926E7,""t,""',
        quote: '"'
        escape: '"'
      .on 'close', ->
        false.should.be.ok
      .on 'error', (e) ->
        e.message.should.match /Invalid closing quote/
        next()

    it.skip 'when around invalid quotes', (next) ->
      csv()
      .from.string("""
        384682,SAMAY Hostel,Jiron "Florida 285"
        """, quote: '"', escape: '"', relax: true)
      # .to.array (data) ->
      #   data.should.eql [ [ '384682', 'SAMAY Hostel', 'Jiron "Florida 285"' ] ]
      #   next()
      .on 'error', (e) ->
        # Error should be thrown unless we remove 
        # the 'relax' option and change our strategy
        e.message.should.match /Invalid closing quote/
        next()

