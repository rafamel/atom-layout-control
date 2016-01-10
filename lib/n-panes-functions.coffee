addUntilNPanes = (n) ->
  paneCount = atom.workspace.getPanes().length
  while paneCount < n
    atom.workspace.getActivePane().splitRight()
    paneCount = atom.workspace.getPanes().length

mergeUntilNPanes = (n) ->
  paneCount = atom.workspace.getPanes().length
  while paneCount > n
    mergeLastTwoPanes()
    paneCount = atom.workspace.getPanes().length

mergeLastTwoPanes = () ->
  panes = atom.workspace.getPanes()
  lastPane = panes[-1..][0]
  secondToLastPane = panes[-2..][0]
  lastPaneItems = lastPane.getItems()
  for item in lastPaneItems
    lastPane.moveItemToPane item, secondToLastPane
  lastPane.destroy()

module.exports =
  ensureNPanes: (n) ->
    paneCount = atom.workspace.getPanes().length
    if paneCount < n
      addUntilNPanes(n)
    else if paneCount > n
      mergeUntilNPanes(n)
