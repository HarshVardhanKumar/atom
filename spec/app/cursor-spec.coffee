Buffer = require 'buffer'
Editor = require 'editor'
$ = require 'jquery'
_ = require 'underscore'
fs = require 'fs'

describe "Cursor", ->
  [buffer, editor, cursor] = []

  beforeEach ->
    buffer = new Buffer(require.resolve('fixtures/sample.js'))
    editor = new Editor
    editor.enableKeymap()
    editor.setBuffer(buffer)
    cursor = editor.getCursors()[0]

  describe "adding and removing of the idle class", ->
    it "removes the idle class while moving, then adds it back when it stops", ->
      advanceClock(200)

      expect(cursor).toHaveClass 'idle'
      cursor.setScreenPosition([1, 2])
      expect(cursor).not.toHaveClass 'idle'

      window.advanceClock(200)
      expect(cursor).toHaveClass 'idle'

      cursor.setScreenPosition([1, 3])
      advanceClock(100)

      cursor.setScreenPosition([1, 4])
      advanceClock(100)
      expect(cursor).not.toHaveClass 'idle'

      advanceClock(100)
      expect(cursor).toHaveClass 'idle'

  describe ".isOnEOL()", ->
    it "only returns true when cursor is on the end of a line", ->
      cursor.setScreenPosition([1,29])
      expect(cursor.isOnEOL()).toBeFalsy()

      cursor.setScreenPosition([1,30])
      expect(cursor.isOnEOL()).toBeTruthy()