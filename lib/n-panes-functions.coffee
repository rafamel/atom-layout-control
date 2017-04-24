getOrientationPanes = (horizontal) ->
  panes = atom.workspace.getPanes()
  if horizontal
    panes.filter (x) -> (x.parent.orientation || 'horizontal') == 'horizontal'
  else
    panes.filter (x) -> (x.parent.orientation || 'vertical') == 'vertical'

addUntilNPanes = (n, horizontal) ->
  paneCount = getOrientationPanes(horizontal).length
  while paneCount < n
    if horizontal
      atom.workspace.getActivePane().splitRight()
    else
      atom.workspace.getActivePane().splitDown()
    paneCount = getOrientationPanes(horizontal).length

mergeUntilNPanes = (n, horizontal) ->
  panes = getOrientationPanes(horizontal)
  paneCount = panes.length
  while paneCount > n
    mergeTwoPanes(panes[-1..][0], panes[-2..][0])
    panes = getOrientationPanes(horizontal)
    paneCount = panes.length

mergeTwoPanes = (lastPane, secondToLastPane) ->
  lastPaneItems = lastPane.getItems()
  for item in lastPaneItems
    lastPane.moveItemToPane item, secondToLastPane
  lastPane.destroy()

module.exports =
  ensurePanes: (n, horizontal) ->
    revPaneCount = getOrientationPanes(!horizontal).length
    if revPaneCount > 1
      mergeUntilNPanes(1, !horizontal)
    paneCount = getOrientationPanes(horizontal).length
    if paneCount < n
      addUntilNPanes(n, horizontal)
    else if paneCount > n
      mergeUntilNPanes(n, horizontal)
  ensureGrid: () ->
    this.ensurePanes(2, true)
    panes = atom.workspace.getPanes()
    for item in panes
      item.splitDown()
