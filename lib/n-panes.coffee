nPanesFunctions = require './n-panes-functions'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    # alert 'hi'
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'alert-alert-alert': => alert('command successful')
      '1-pane-layout': => @ensureNPanes(1)
      '2-pane-layout': => @ensureNPanes(2)
      '3-pane-layout': => @ensureNPanes(3)
      '4-pane-layout': => @ensureNPanes(4)
      '5-pane-layout': => @ensureNPanes(5)

  deactivate: ->
    @subscriptions.dispose()

  ensureNPanes: nPanesFunctions.ensureNPanes

  inverse: ->
    if editor = atom.workspace.getActiveTextEditor()
        sReverseString = editor.getSelectedText().split(/\s/).reverse().join(' ')
        editor.insertText(sReverseString,{'select':true})
