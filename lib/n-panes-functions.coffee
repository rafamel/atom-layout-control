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
  while panes.length > n
    mergeTwoPanes(panes[-1..][0], panes[-2..][0])
    panes = getOrientationPanes(horizontal)

mergeTwoPanes = (lastPane, secondToLastPane) ->
  lastPaneItems = lastPane.getItems()
  for item in lastPaneItems
    lastPane.moveItemToPane item, secondToLastPane
  lastPane.destroy()

module.exports =
  ensurePanes: (n, horizontal) ->
    revPaneCount = getOrientationPanes(!horizontal).length
    paneCount = getOrientationPanes(horizontal).length
    # If true, there is a number of horizontal panes within vertical panes or vice versa
    forceToOneA = (revPaneCount > 0 and paneCount > 1) or (revPaneCount > 1 and paneCount > 0)
    # If true, possible transition from grid to horizontal panes
    forceToOneB = (!horizontal) and paneCount >= 4 and paneCount % 2 == 0
    if forceToOneA or forceToOneB
      # We can't properly identify the panes, we'll merge all until only one pane is left
      panes = atom.workspace.getPanes()
      paneCount = 1
      while panes.length > 1
        mergeTwoPanes(panes[-1..][0], panes[-2..][0])
        panes = atom.workspace.getPanes()
    else if revPaneCount > 1
      mergeUntilNPanes(1, !horizontal)
    if paneCount < n
      addUntilNPanes(n, horizontal)
    else if paneCount > n
      mergeUntilNPanes(n, horizontal)
  ensureGrid: () ->
    this.ensurePanes(2, true)
    panes = atom.workspace.getPanes()
    for item in panes
      item.splitDown()
