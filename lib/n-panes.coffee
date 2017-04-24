nPanesFunctions = require './n-panes-functions'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    # alert 'hi'
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'alert-alert-alert': => alert('command successful')
      '1-pane-layout': => @ensurePanes(1, true)
      '2-pane-layout': => @ensurePanes(2, true)
      '3-pane-layout': => @ensurePanes(3, true)
      '4-pane-layout': => @ensurePanes(4, true)
      '2-rows-layout': => @ensurePanes(2, false)
      '3-rows-layout': => @ensurePanes(3, false)
      'grid-layout': => @ensureGrid()

  deactivate: ->
    @subscriptions.dispose()

  ensurePanes: nPanesFunctions.ensurePanes
  ensureGrid: nPanesFunctions.ensureGrid

  inverse: ->
    if editor = atom.workspace.getActiveTextEditor()
        sReverseString = editor.getSelectedText().split(/\s/).reverse().join(' ')
        editor.insertText(sReverseString,{'select':true})
