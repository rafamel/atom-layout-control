'use babel';

function getPanes() {
    let panes = atom.workspace.getPanes().filter(
        x => x.parent
        && x.parent.constructor
        && x.parent.constructor.name === 'PaneAxis'
    );
    if (!panes.length) {
        panes = atom.workspace.getPanes().filter(
            x => x.activeItem
            && x.activeItem.constructor
            && x.activeItem.constructor.name === 'TextEditor'
        );
    }
    return panes;
}

function getOrientationPanes(horizontal) {
    let panes = getPanes();
    if (horizontal) {
        return panes.filter(x => (x.parent.orientation || 'horizontal') === 'horizontal');
    } else {
        return panes.filter(x => (x.parent.orientation || 'vertical') === 'vertical');
    }
};

function addUntilNPanes(n, horizontal) {
    let panes = getOrientationPanes(horizontal),
        paneCount = panes.length,
        promise = Promise.resolve([panes, paneCount]);
    if (paneCount === 0) {
        promise = new Promise((accept,reject) => {
            atom.workspace.open()
            .then(() => {
                let panes = getOrientationPanes(horizontal);
                accept([panes, panes.length]);
            })
            .catch((err) => reject(err));
        });
    }
    return new Promise((accept,reject) => {
        promise.then(([panes, paneCount]) => {
            if (horizontal) panes.slice(-1)[0].splitRight();
            else panes.slice(-1)[0].splitDown();
            if (paneCount+1 < n) {
                addUntilNPanes(n, horizontal)
                .then(x => accept(x))
                .catch((err) => reject(err));
            }
            else accept();
        })
        .catch((err) => { reject(err) });
    });
};

function mergeTwoPanes(lastPane, secondToLastPane) {
    let lastPaneItems = lastPane.getItems();
    for (let item of Array.from(lastPaneItems)) {
        lastPane.moveItemToPane(item, secondToLastPane);
    }
    return lastPane.destroy();
};

function mergeUntilNPanes(n, horizontal) {
    let panes = getOrientationPanes(horizontal);
    let result = [];
    while (panes.length > n) {
        mergeTwoPanes(panes.slice(-1)[0], panes.slice(-2)[0]);
        result.push(panes = getOrientationPanes(horizontal));
    }
    return Promise.resolve();
};

// Main functions

function ensurePanes(n, horizontal) {
    let revPaneCount = getOrientationPanes(!horizontal).length,
        paneCount = getOrientationPanes(horizontal).length;
    // If true, there is a number of horizontal panes within vertical panes or vice versa
    let forceToOneA = ((revPaneCount > 0) && (paneCount > 1))
                            || ((revPaneCount > 1) && (paneCount > 0));
    // If true, possible transition from grid to horizontal panes
    let forceToOneB = (!horizontal) && (paneCount >= 4) && ((paneCount % 2) === 0);
    if (forceToOneA || forceToOneB) {
        // We can't properly identify the panes, we'll merge all until only one pane is left
        let panes = getPanes();
            paneCount = 1;
        while (panes.length > 1) {
            mergeTwoPanes(panes.slice(-1)[0], panes.slice(-2)[0]);
            panes = getPanes();
        }
    } else if (revPaneCount > 1) {
        mergeUntilNPanes(1, !horizontal);
    }
    paneCount = getOrientationPanes(horizontal).length;
    if (paneCount < n && n > 1) return addUntilNPanes(n, horizontal);
    else if (paneCount > n) return mergeUntilNPanes(n, horizontal);
    return Promise.resolve();
}

function ensureGrid() {
    ensurePanes(2, true).then(() => {
        let panes = getPanes();
        Array.from(panes).map((item) => item.splitDown());
    })
    .catch((err) => {}); // let it die
}

export default { ensurePanes, ensureGrid };
