/* OctaScenes v0.1.2 — Max 8 legacy js / Live 11.
 * All entry messages are deferred by the patch. No Live API writes from
 * observer callbacks. Persistent live.observer objects own binding identity;
 * the hidden pattr blob owns scene/base data. Runtime IDs never enter the blob.
 */
autowatch = 0;
inlets = 1;
outlets = 3;
include("scene-core.js");

var core = new SceneCore();
var state = {enabled: false, mode: 0, scene: 0, a: 0, b: 1, x: 0, slot: 0};
var refs = [], bindings = [], controlled = [], epochs = [], restorePending = [];
var ready = false, editing = false, mapArmed = false, editSeen = [];
var ownDevicePath = "", mapPrevious = 0, mapUntil = 0, editAfter = 0;
var clipboard = null, keyCounter = 0, tasks = [], pollTask = null;
var initializing = false, dirtyTask = null, updateCount = 0, editGeneration = 0;
var deviceIsActive = true;
var i;
for (i = 0; i < 32; i += 1) { refs[i] = null; bindings[i] = 0; controlled[i] = false; epochs[i] = 0; restorePending[i] = false; }

function scalar(value) { return value instanceof Array ? value[0] : value; }
function finite(value) { return typeof value === "number" && isFinite(value); }
function clamp(value) { return Math.max(0, Math.min(1, value)); }
function validIndex(value, count) { return finite(value) && value === Math.floor(value) && value >= 0 && value < count; }
function ui(name, command, value) {
    try {
        var box = this.patcher.getnamed(name);
        if (box) { box.message(command, value); }
    } catch (ignore) {}
}
function uiColor(name, attribute, color) {
    try {
        var box = this.patcher.getnamed(name);
        if (box) { box.message(attribute, color[0], color[1], color[2], color[3]); }
    } catch (ignore) {}
}
function status(text) { outlet(1, String(text)); }
function later(callback, ms) {
    var task = new Task(function () {
        var at = tasks.indexOf(task);
        if (at >= 0) { tasks.splice(at, 1); }
        try { callback(); } catch (error) { status("ERROR: " + error.message); }
    }, this);
    tasks.push(task);
    task.schedule(ms);
}
function dirty() {
    if (dirtyTask) { return; }
    dirtyTask = new Task(function () { dirtyTask = null; notifyclients(); }, this);
    dirtyTask.schedule(50);
}
function apiFor(id) {
    var api = new LiveAPI(null, "id " + Number(id));
    api.mode = 0;
    return api;
}
function apiPath(api) { return String(api.path).replace(/^"|"$/g, ""); }
function apiNumber(api, property) { return Number(scalar(api.get(property))); }
function apiText(api, property) { return String(scalar(api.get(property))); }
function safeAutomation(ref) {
    // Unknown automation state is not safe for writing the editable base.
    try { return apiNumber(ref.api, "automation_state"); } catch (ignore) { return -1; }
}
function readNormalized(slotIndex) {
    var ref = refs[slotIndex], meta = core.getMapping(slotIndex), raw;
    if (!ref || !meta || !ref.api.id) { throw new Error("Unavailable mapping " + (slotIndex + 1)); }
    raw = apiNumber(ref.api, "value");
    if (!finite(raw)) { throw new Error("Invalid parameter value"); }
    return clamp((raw - meta.min) / (meta.max - meta.min));
}
function actualValue(slotIndex, normalized) {
    var meta = core.getMapping(slotIndex);
    var value = meta.min + clamp(normalized) * (meta.max - meta.min);
    return meta.quantized ? Math.max(meta.min, Math.min(meta.max, Math.round(value))) : value;
}
function setNative(slotIndex, normalized) {
    var ref = refs[slotIndex];
    if (ref && ref.api.id && safeAutomation(ref) === 0) {
        ref.api.set("value", actualValue(slotIndex, normalized));
    }
}
function sendTarget(slotIndex, value) {
    var ref = refs[slotIndex];
    if (!ref || !ref.api.id || !core.getMapping(slotIndex)) { return; }
    epochs[slotIndex] += 1; // Invalidate queued release/restoration work.
    controlled[slotIndex] = true; restorePending[slotIndex] = false;
    outlet(0, "target", slotIndex, ref.id, actualValue(slotIndex, value));
}
function releaseSlot(slotIndex, restoreBase) {
    var epoch, base = core.getBase()[slotIndex], wasControlled = controlled[slotIndex];
    epochs[slotIndex] += 1;
    epoch = epochs[slotIndex];
    controlled[slotIndex] = false; restorePending[slotIndex] = !!restoreBase;
    outlet(0, "release", slotIndex);
    if (restoreBase && base !== null && refs[slotIndex]) {
        // Allow Live's remote ownership to release before native writes. Keep
        // active automation intact: once released, the arrangement owns it.
        later(function () {
            if (epochs[slotIndex] === epoch && !controlled[slotIndex]) {
                setNative(slotIndex, base); restorePending[slotIndex] = false;
            }
        }, wasControlled ? 30 : 0);
    }
}
function applyPerformance() {
    var values, slotIndex;
    if (!ready || !state.enabled || editing || !deviceIsActive) { return; }
    values = state.mode ? core.evaluateMorph(state.a, state.b, state.x) : core.evaluateDirect(state.scene);
    for (slotIndex = 0; slotIndex < 32; slotIndex += 1) {
        if (!refs[slotIndex] || !core.getMapping(slotIndex)) { continue; }
        if (values[slotIndex] === null) {
            if (controlled[slotIndex]) { releaseSlot(slotIndex, true); }
        } else { sendTarget(slotIndex, values[slotIndex]); }
    }
}
function refreshMenus() {
    var slotIndex, meta, label;
    try {
        var menu = this.patcher.getnamed("slot");
        menu.message("clear");
        for (slotIndex = 0; slotIndex < 32; slotIndex += 1) {
            meta = core.getMapping(slotIndex);
            label = (slotIndex < 9 ? "0" : "") + (slotIndex + 1) + " - ";
            label += meta ? (refs[slotIndex] ? "" : "[MISSING] ") + meta.label : "Empty";
            menu.message("append", label);
        }
        menu.message("set", state.slot);
    } catch (ignore) {}
}
function refresh() {
    var slotIndex, locks, count = 0, meta = core.getMapping(state.slot), detail;
    ui("enable", "set", state.enabled ? 1 : 0);
    ui("mode", "set", state.mode);
    ui("edit", "set", editing ? 1 : 0);
    ui("a", "set", state.a + 1); ui("b", "set", state.b + 1);
    ui("xfade", "set", state.x * 127);
    for (slotIndex = 0; slotIndex < 16; slotIndex += 1) {
        // Selection is independent of the button's momentary press/release value.
        var selected = slotIndex === state.scene;
        var name = "scene_" + slotIndex;
        var label = (selected ? ">" : "") + (slotIndex + 1);
        var background = selected ? [0.27, 0.83, 0.67, 1.0] : [0.22, 0.25, 0.29, 1.0];
        var foreground = selected ? [0.11, 0.12, 0.14, 1.0] : [0.91, 0.93, 0.94, 1.0];
        ui(name, "text", label); ui(name, "texton", label);
        uiColor(name, "bgcolor", background); uiColor(name, "activebgcolor", background);
        uiColor(name, "textcolor", foreground); uiColor(name, "activetextcolor", foreground);
    }
    locks = core.getScene(state.scene).locks;
    for (slotIndex = 0; slotIndex < 32; slotIndex += 1) { if (locks[slotIndex] !== null) { count += 1; } }
    detail = "Scene " + (state.scene + 1) + " | " + count + " locks | ";
    detail += meta ? meta.label + " | " + (locks[state.slot] === null ? "BASE" : "LOCK " + Math.round(locks[state.slot] * 1000) / 10 + "%") : "MAP then click a parameter in Live.";
    if (meta && refs[state.slot]) {
        var desired = editing || !state.mode ? core.evaluateDirect(state.scene) : core.evaluateMorph(state.a, state.b, state.x);
        if (desired[state.slot] !== null) {
            detail += " | Target " + Math.round(actualValue(state.slot, desired[state.slot]) * 1000) / 1000;
        }
        try { detail += " | Live " + Math.round(apiNumber(refs[state.slot].api, "value") * 1000) / 1000; }
        catch (ignore) { detail += " | Live unavailable"; }
    }
    ui("detail", "set", detail);
}
function validateBinding(slotIndex) {
    var meta = core.getMapping(slotIndex), api, min, max, quantized, id = bindings[slotIndex], j;
    refs[slotIndex] = null;
    if (!meta || !id) { return; }
    try {
        api = apiFor(id);
        min = apiNumber(api, "min"); max = apiNumber(api, "max");
        quantized = apiNumber(api, "is_quantized") !== 0;
        if (String(api.type) !== "DeviceParameter" || min !== meta.min || max !== meta.max || quantized !== meta.quantized) {
            status("Mapping " + (slotIndex + 1) + " changed type/range. Remap with scenes OFF.");
            return;
        }
        if (ownDevicePath && apiPath(api).indexOf(ownDevicePath + " ") === 0) { return; }
        for (j = 0; j < 32; j += 1) {
            if (j !== slotIndex && refs[j] && refs[j].id === id) { return; }
        }
        refs[slotIndex] = {api: api, id: id};
    } catch (ignore) {}
}
function binding(slotIndex, id) {
    slotIndex = Number(slotIndex); id = Number(id);
    if (!validIndex(slotIndex, 32) || !finite(id) || id < 0) { return; }
    if (bindings[slotIndex] === id && refs[slotIndex]) { return; }
    if (controlled[slotIndex]) { releaseSlot(slotIndex, false); }
    bindings[slotIndex] = id;
    if (!ready) { return; }
    validateBinding(slotIndex);
    refreshMenus(); refresh(); applyPerformance();
}
function initialize() {
    if (initializing || ready) { return; }
    initializing = true;
    // Live's persisted pattr state and observers may arrive independently.
    later(function () {
        var own;
        try { own = new LiveAPI(null, "this_device"); ownDevicePath = apiPath(own); }
        catch (error) { status("Live API unavailable; open as a Max Audio Effect in Live 11."); initializing = false; return; }
        ready = true; initializing = false;
        for (var j = 0; j < 32; j += 1) { validateBinding(j); }
        refreshMenus(); refresh(); applyPerformance();
        status("Ready. OFF: map/base. ON + EDIT: change scene. DIRECT recalls instantly.");
        pollTask = new Task(poll, this); pollTask.interval = 50; pollTask.repeat();
    }, 150);
}
function getvalueof() {
    // Max pattr stores one string atom. No IDs/paths/tasks/LiveAPI objects.
    return [JSON.stringify({format: "OctaScenes", version: 1, core: core.exportState(), performance: state})];
}
function setvalueof() {
    var args = arrayfromargs(arguments), text, parsed, next, s, j;
    if (!args.length || (args.length === 1 && (args[0] === 0 || args[0] === ""))) { return; }
    try {
        text = String(args[0]); parsed = JSON.parse(text);
        if (parsed.format !== "OctaScenes" || parsed.version !== 1) { throw new Error("Unsupported saved state"); }
        next = new SceneCore(parsed.core); s = parsed.performance;
        if (!s || typeof s.enabled !== "boolean" || !validIndex(s.mode, 2) ||
            !validIndex(s.scene, 16) || !validIndex(s.a, 16) || !validIndex(s.b, 16) ||
            !validIndex(s.slot, 32) || !finite(s.x) || s.x < 0 || s.x > 1) { throw new Error("Invalid saved controls"); }
        if (ready) { for (j = 0; j < 32; j += 1) { releaseSlot(j, false); } }
        core = next;
        state = {enabled:s.enabled, mode:s.mode, scene:s.scene, a:s.a, b:s.b, x:s.x, slot:s.slot};
        editing = false; mapArmed = false; editGeneration += 1;
        if (ready) {
            for (j = 0; j < 32; j += 1) { validateBinding(j); }
            refreshMenus(); refresh(); applyPerformance();
        }
    } catch (error) { status("Saved scene data was rejected: " + error.message); }
}
function enable(value) {
    var base, j, count = 0;
    if (!ready) { return; }
    value = Number(value) !== 0;
    if (state.enabled === value) { return; }
    mapArmed = false;
    if (value) {
        base = core.getBase();
        for (j = 0; j < 32; j += 1) {
            if (!refs[j]) { continue; }
            // Cancel pending OFF restorations before sampling the new base.
            epochs[j] += 1;
            try { if (!restorePending[j]) { base[j] = readNormalized(j); } restorePending[j] = false; count += 1; } catch (ignore) {}
        }
        if (!count) { status("Map at least one available parameter first."); refresh(); return; }
        core.setBase(base); state.enabled = true; applyPerformance();
        status("Scenes ON. Shared base captured. EDIT to write selected scene.");
    } else {
        if (editing) { pollEdits(); }
        editing = false; editGeneration += 1; state.enabled = false;
        for (j = 0; j < 32; j += 1) { if (core.getMapping(j)) { releaseSlot(j, true); } }
        status("Scenes OFF. Base restored; active Live automation resumes.");
    }
    refresh(); dirty();
}
function scene(value) {
    value = Number(value);
    if (!ready || !validIndex(value, 16)) { return; }
    if (editing) { pollEdits(); }
    state.scene = value;
    if (editing) { prepareEdit(); }
    else {
        if (state.enabled && state.mode === 0) { applyPerformance(); }
        status("Scene " + (value + 1) + (state.mode ? " selected for EDIT. A/B choose MORPH endpoints." : " selected."));
    }
    refresh(); dirty();
}
function mode(value) {
    if (!ready) { return; }
    state.mode = Number(value) ? 1 : 0;
    applyPerformance(); refresh(); dirty();
}
function a(value) { chooseEndpoint("a", value); }
function b(value) { chooseEndpoint("b", value); }
function chooseEndpoint(which, value) {
    value = Number(value);
    if (!ready || !validIndex(value, 16)) { return; }
    state[which] = value; applyPerformance(); refresh(); dirty();
}
function xfade(value) {
    value = Number(value);
    if (!ready || !finite(value)) { return; }
    state.x = clamp(value / 127);
    // Moving the fader in DIRECT never silently takes over a recalled scene.
    if (state.mode) { applyPerformance(); }
    refresh(); dirty();
}
function slot(value) {
    value = Number(value);
    if (!ready || !validIndex(value, 32)) { return; }
    state.slot = value; refresh(); dirty();
}
function map() {
    if (!ready) { return; }
    if (state.enabled) { status("Switch scenes OFF before changing mappings."); return; }
    mapArmed = !mapArmed;
    if (mapArmed) {
        try { mapPrevious = Number(new LiveAPI(null, "live_set view selected_parameter").id); }
        catch (ignore) { mapPrevious = 0; }
        mapUntil = Date.now() + 20000;
    }
    status(mapArmed ? "MAP armed: click a different parameter in Live (20 seconds)." : "MAP cancelled.");
}
function learnSelected() {
    var api, id, j, min, max, label, meta, base;
    if (Date.now() > mapUntil) { mapArmed = false; status("MAP timed out. Press MAP to try again."); return; }
    try {
        api = new LiveAPI(null, "live_set view selected_parameter"); id = Number(api.id);
        if (!id || id === mapPrevious || String(api.type) !== "DeviceParameter") { return; }
        if (ownDevicePath && apiPath(api).indexOf(ownDevicePath + " ") === 0) { return; }
        for (j = 0; j < 32; j += 1) {
            if (j !== state.slot && refs[j] && refs[j].id === id) {
                status("Already mapped in slot " + (j + 1) + "."); mapArmed = false; return;
            }
        }
        min = apiNumber(api, "min"); max = apiNumber(api, "max");
        if (!finite(min) || !finite(max) || max <= min || apiNumber(api, "is_enabled") === 0) { return; }
        label = apiText(api, "name");
        meta = core.getMapping(state.slot);
        if (!meta || !refs[state.slot] || refs[state.slot].id !== id) {
            keyCounter += 1;
            meta = {key:"mapping-" + Date.now() + "-" + keyCounter, label:label,
                    min:min, max:max, quantized:apiNumber(api, "is_quantized") !== 0};
        }
        core.setMapping(state.slot, meta);
        bindings[state.slot] = id; refs[state.slot] = {api:apiFor(id), id:id};
        base = core.getBase(); base[state.slot] = readNormalized(state.slot); core.setBase(base);
        outlet(0, "mapid", state.slot, id);
        mapArmed = false; refreshMenus(); refresh(); dirty();
        status("Mapped slot " + (state.slot + 1) + ": " + label);
    } catch (error) { status("Cannot map this parameter: " + error.message); mapArmed = false; }
}
function unmap() {
    if (!ready) { return; }
    if (state.enabled) { status("Switch scenes OFF before UNMAP."); return; }
    releaseSlot(state.slot, false); outlet(0, "mapid", state.slot, 0);
    refs[state.slot] = null; bindings[state.slot] = 0;
    core.unmap(state.slot); refreshMenus(); refresh(); dirty();
    status("Mapping and its scene locks removed.");
}
function focus() {
    var ref = refs[state.slot], path, parent, view;
    if (!ready || !ref) { status("Select an available mapped parameter."); return; }
    try {
        path = apiPath(ref.api); parent = path.replace(/ parameters \d+$/, "");
        if (parent !== path && parent.indexOf(" devices ") >= 0) {
            view = new LiveAPI(null, "live_set view");
            view.call("select_device", "id", Number(new LiveAPI(null, parent).id));
            status("Opened the parameter's device. Select its knob in Live.");
        } else { status("Mapped mixer parameter: " + core.getMapping(state.slot).label); }
    } catch (ignore) { status("Open the mapped device manually in Live."); }
}
function edit(value) {
    var j;
    if (!ready) { return; }
    value = Number(value) !== 0;
    if (value === editing) { return; }
    if (value) {
        if (!deviceIsActive) { status("Enable the native device activator before EDIT."); refresh(); return; }
        if (!state.enabled) { status("Switch scenes ON before EDIT."); refresh(); return; }
        for (j = 0; j < 32; j += 1) {
            if (refs[j] && safeAutomation(refs[j]) !== 0) {
                status("EDIT blocked: slot " + (j + 1) + " has automation. Stop/remove its automation first."); refresh(); return;
            }
        }
        editing = true; prepareEdit();
    } else {
        pollEdits(); editing = false; editGeneration += 1;
        // Restore underlying base after editing, then reapply the performance
        // layer. Slots that remain unowned in MORPH also need their base back.
        for (j = 0; j < 32; j += 1) { if (refs[j]) { releaseSlot(j, true); } }
        later(applyPerformance, 40);
        status("Scene " + (state.scene + 1) + " saved. Performance resumed.");
    }
    refresh(); dirty();
}
function prepareEdit() {
    var values = core.evaluateDirect(state.scene), sceneAtStart = state.scene, j;
    editGeneration += 1;
    var generation = editGeneration;
    editAfter = Date.now() + 180;
    for (j = 0; j < 32; j += 1) { releaseSlot(j, false); }
    // Release first; user can then turn the actual Live knobs normally.
    later(function () {
        if (!editing || state.scene !== sceneAtStart || generation !== editGeneration) { return; }
        for (var k = 0; k < 32; k += 1) {
            editSeen[k] = null;
            if (values[k] !== null && refs[k]) {
                setNative(k, values[k]); editSeen[k] = values[k];
            }
        }
        // Prime from actual accepted values (plugins can quantize themselves).
        later(function () {
            if (!editing || state.scene !== sceneAtStart || generation !== editGeneration) { return; }
            for (var k = 0; k < 32; k += 1) {
                if (refs[k]) { try { editSeen[k] = readNormalized(k); } catch (ignore) {} }
            }
            status("EDIT Scene " + (state.scene + 1) + ": turn mapped knobs; only changes become locks.");
        }, 60);
    }, 40);
}
function pollEdits() {
    var j, value, changed = false;
    if (!editing || Date.now() < editAfter) { return; }
    for (j = 0; j < 32; j += 1) {
        if (!refs[j] || editSeen[j] === null || editSeen[j] === undefined) { continue; }
        try {
            if (safeAutomation(refs[j]) !== 0) { continue; }
            value = readNormalized(j);
            if (Math.abs(value - editSeen[j]) > 0.000001) {
                core.setLock(state.scene, j, value); editSeen[j] = value; changed = true;
            }
        } catch (ignore) {}
    }
    if (changed) { dirty(); refresh(); }
}
function clearlock() {
    if (!ready) { return; }
    core.clearLock(state.scene, state.slot);
    if (editing) { prepareEdit(); } else { applyPerformance(); }
    refresh(); dirty(); status("Selected parameter lock cleared from Scene " + (state.scene + 1) + ".");
}
function clearscene() {
    if (!ready) { return; }
    core.clearScene(state.scene);
    if (editing) { prepareEdit(); } else { applyPerformance(); }
    refresh(); dirty(); status("Scene " + (state.scene + 1) + " cleared; it now uses BASE.");
}
function copy() {
    if (!ready) { return; }
    if (editing) { pollEdits(); }
    clipboard = {scene:core.getScene(state.scene), mappings:core.getMappings()};
    status("Copied Scene " + (state.scene + 1) + ". Select destination, then PASTE SCENE.");
}
function paste() {
    var j;
    if (!ready || !clipboard) { status("COPY SCENE first."); return; }
    core.clearScene(state.scene);
    for (j = 0; j < 32; j += 1) {
        if (clipboard.scene.locks[j] !== null && core.getMapping(j) && clipboard.mappings[j] &&
            core.getMapping(j).key === clipboard.mappings[j].key) { core.setLock(state.scene, j, clipboard.scene.locks[j]); }
    }
    if (editing) { prepareEdit(); } else { applyPerformance(); }
    refresh(); dirty(); status("Pasted locks into Scene " + (state.scene + 1) + ".");
}
function poll() {
    if (!ready) { return; }
    if (mapArmed) { learnSelected(); }
    if (editing) { pollEdits(); }
    updateCount += 1;
    if (updateCount % 20 === 0) {
        refresh();
        for (var j = 0; j < 32; j += 1) {
            if (refs[j] && !refs[j].api.id) {
                releaseSlot(j, false); refs[j] = null; refreshMenus();
                status("Mapped target removed. Slot " + (j + 1) + " is unavailable.");
            }
        }
    }
}
function freebang() {
    if (pollTask) { pollTask.cancel(); }
    if (dirtyTask) { dirtyTask.cancel(); }
    for (var j = 0; j < tasks.length; j += 1) { tasks[j].cancel(); }
    tasks = [];
    for (j = 0; j < 32; j += 1) { outlet(0, "release", j); }
}

// The native device activator must release ownership too. Stored scenes and
// ON state survive bypass; returning from bypass does not recapture the base.
function deviceactive(value) {
    deviceIsActive = Number(value) !== 0;
    if (!ready) { return; }
    if (!deviceIsActive) {
        if (editing) { pollEdits(); }
        editing = false; editGeneration += 1; mapArmed = false;
        for (var j = 0; j < 32; j += 1) { if (core.getMapping(j)) { releaseSlot(j, true); } }
    } else { applyPerformance(); }
    refresh();
}
