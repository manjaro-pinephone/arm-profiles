/*
 * This file is part of the Dash-To-Panel extension for Gnome 3
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;
const Soup = imports.gi.Soup;
const FileUtils = imports.misc.fileUtils;

const Me = imports.misc.extensionUtils.getCurrentExtension();
const Gettext = imports.gettext.domain(Me.metadata['gettext-domain']);
const _ = Gettext.gettext;

let apiUrl = '';

function init() {
    Me.settings.connect('changed::force-check-update', () => {
        if (Me.settings.get_boolean('force-check-update')) {
            checkForUpdate(true);
            Me.settings.set_boolean('force-check-update', false);
        }
    });

}

function checkForUpdate(fromSettings) {
    if (!apiUrl) {
        return notifyError(_('Unavailable when installed from extensions.gnome.org'));
    }

}

function notifyError(err) {
    Me.imports.utils.notify(_('Error: ') + err, 'dialog-error', null, true);
}

function notify(msg, action) {
    Me.imports.utils.notify(msg, 'dialog-information', action, true);
}

