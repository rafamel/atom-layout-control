'use babel';

import Functions from './functions';
import { CompositeDisposable } from 'atom';

// This is your main singleton.
// The whole state of your package will be stored and managed here.

const ensurePanes = Functions.ensurePanes,
    ensureGrid = Functions.ensureGrid;

const layoutShortcuts = {
    subscriptions: null,
    activate() {
        // Activates and restores the previous session of your package.
        this.subscriptions = new CompositeDisposable;
        return this.subscriptions.add(atom.commands.add('atom-workspace', {
            '1-pane-layout': () => ensurePanes(1, true),
            '2-columns-layout': () => ensurePanes(2, true),
            '3-columns-layout': () => ensurePanes(3, true),
            '4-columns-layout': () => ensurePanes(4, true),
            '2-rows-layout': () => ensurePanes(2, false),
            '3-rows-layout': () => ensurePanes(3, false),
            'grid-layout': () => ensureGrid()
        }));
    },
    deactivate() {
        // When the user or Atom itself kills a window, this method is called.
        return this.subscriptions.dispose();
    }
};

export default layoutShortcuts;
