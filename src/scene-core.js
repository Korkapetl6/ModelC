/* OctaScenes scene engine. ES5 only: shared by Max's legacy js and Node.
 *
 * All stored parameter values are normalized to 0..1. Null means unmapped
 * (base) or no scene lock. A mapping's min/max describe its actual Live units.
 * This module never persists runtime Live API object IDs.
 */
(function (root, factory) {
    if (typeof module === "object" && module.exports) {
        module.exports = factory();
    } else {
        root.SceneCore = factory();
    }
}(this, function () {
    "use strict";

    var SLOT_COUNT = 32;
    var SCENE_COUNT = 16;
    var SCHEMA_VERSION = 1;
    var own = Object.prototype.hasOwnProperty;

    function fail(message) { throw new Error("OctaScenes: " + message); }
    function finite(value) { return typeof value === "number" && isFinite(value); }
    function clamp(value) { return Math.max(0, Math.min(1, value)); }
    function array(value) { return Object.prototype.toString.call(value) === "[object Array]"; }
    function object(value) { return value !== null && typeof value === "object" && !array(value); }
    function index(value, count, label) {
        if (!finite(value) || value !== Math.floor(value) || value < 0 || value >= count) {
            fail(label + " must be an integer from 0 to " + (count - 1));
        }
        return value;
    }
    function text(value, limit, label) {
        if (typeof value !== "string" || value.length > limit || !/\S/.test(value)) {
            fail(label + " must be nonempty text of at most " + limit + " characters");
        }
        return value;
    }
    function normalized(value, strict) {
        if (!finite(value) || (strict && (value < 0 || value > 1))) {
            fail("parameter values must be finite" + (strict ? " and within 0..1" : ""));
        }
        return clamp(value);
    }
    function nulls(count) {
        var result = [], i;
        for (i = 0; i < count; i += 1) { result.push(null); }
        return result;
    }
    function exactArray(value, count, label) {
        if (!array(value) || value.length !== count) { fail(label + " must contain " + count + " entries"); }
    }
    function keys(value, allowed, required, label) {
        var key, i;
        if (!object(value)) { fail(label + " must be an object"); }
        for (key in value) {
            if (own.call(value, key) && allowed.indexOf(key) === -1) { fail("unknown " + label + " field: " + key); }
        }
        for (i = 0; i < required.length; i += 1) {
            if (!own.call(value, required[i])) { fail("missing " + label + " field: " + required[i]); }
        }
    }
    function mapping(value, strict) {
        var result;
        if (!object(value)) { fail("mapping must be an object"); }
        if (strict) {
            keys(value, ["key", "label", "min", "max", "quantized", "steps"],
                ["key", "label", "min", "max", "quantized"], "mapping");
        }
        if (!finite(value.min) || !finite(value.max) || value.max <= value.min || !finite(value.max - value.min)) {
            fail("mapping min/max must define a finite increasing range");
        }
        if (value.quantized !== undefined && typeof value.quantized !== "boolean") {
            fail("mapping quantized must be boolean");
        }
        result = {
            key: text(value.key, 4096, "mapping key"),
            label: text(value.label === undefined ? value.key : value.label, 256, "mapping label"),
            min: value.min,
            max: value.max,
            quantized: value.quantized === true
        };
        if (value.steps !== undefined) {
            if (!finite(value.steps) || value.steps !== Math.floor(value.steps) || value.steps < 2) {
                fail("mapping steps must be an integer of at least 2");
            }
            result.steps = value.steps;
        }
        return result;
    }
    function copyMapping(value) { return value === null ? null : mapping(value, true); }
    function copyScene(value) { return { name: value.name, locks: value.locks.slice(0) }; }
    function blankState() {
        var result = { schemaVersion: SCHEMA_VERSION, mappings: nulls(SLOT_COUNT), base: nulls(SLOT_COUNT), scenes: [] }, i;
        for (i = 0; i < SCENE_COUNT; i += 1) {
            result.scenes.push({ name: "Scene" + (i < 9 ? "0" : "") + (i + 1), locks: nulls(SLOT_COUNT) });
        }
        return result;
    }
    function quantize(value, meta) {
        var actual;
        if (!meta.quantized) { return value; }
        actual = Math.round(meta.min + value * (meta.max - meta.min));
        return clamp((actual - meta.min) / (meta.max - meta.min));
    }
    function validateState(value) {
        var next = blankState(), seen = [], i, j, entry, v;
        keys(value, ["schemaVersion", "mappings", "base", "scenes"],
            ["schemaVersion", "mappings", "base", "scenes"], "state");
        if (value.schemaVersion !== SCHEMA_VERSION) { fail("unsupported state schema version"); }
        exactArray(value.mappings, SLOT_COUNT, "mappings");
        exactArray(value.base, SLOT_COUNT, "base");
        exactArray(value.scenes, SCENE_COUNT, "scenes");
        for (i = 0; i < SLOT_COUNT; i += 1) {
            entry = value.mappings[i];
            if (entry === null) {
                if (value.base[i] !== null) { fail("unmapped slots must have null base values"); }
            } else {
                next.mappings[i] = mapping(entry, true);
                if (seen.indexOf(next.mappings[i].key) !== -1) { fail("duplicate mapping key"); }
                seen.push(next.mappings[i].key);
                next.base[i] = normalized(value.base[i], true);
            }
        }
        for (i = 0; i < SCENE_COUNT; i += 1) {
            entry = value.scenes[i];
            keys(entry, ["name", "locks"], ["name", "locks"], "scene");
            next.scenes[i].name = text(entry.name, 64, "scene name");
            exactArray(entry.locks, SLOT_COUNT, "scene locks");
            for (j = 0; j < SLOT_COUNT; j += 1) {
                v = entry.locks[j];
                if (v !== null) {
                    if (next.mappings[j] === null) { fail("unmapped slots cannot have scene locks"); }
                    next.scenes[i].locks[j] = normalized(v, true);
                }
            }
        }
        return next;
    }

    function SceneCore(state) {
        this._state = blankState();
        if (state !== undefined) { this.importState(state); }
    }
    SceneCore.SLOT_COUNT = SLOT_COUNT;
    SceneCore.SCENE_COUNT = SCENE_COUNT;
    SceneCore.SCHEMA_VERSION = SCHEMA_VERSION;

    SceneCore.prototype.setMapping = function (slot, meta) {
        var next = mapping(meta, false), previous, i;
        index(slot, SLOT_COUNT, "slot");
        for (i = 0; i < SLOT_COUNT; i += 1) {
            if (i !== slot && this._state.mappings[i] !== null && this._state.mappings[i].key === next.key) {
                fail("target is already mapped to slot " + i);
            }
        }
        previous = this._state.mappings[slot];
        if (previous === null || previous.key !== next.key) {
            for (i = 0; i < SCENE_COUNT; i += 1) { this._state.scenes[i].locks[slot] = null; }
            this._state.base[slot] = 0;
        }
        this._state.mappings[slot] = next;
        return this;
    };
    SceneCore.prototype.unmap = function (slot) {
        var i;
        index(slot, SLOT_COUNT, "slot");
        this._state.mappings[slot] = null;
        this._state.base[slot] = null;
        for (i = 0; i < SCENE_COUNT; i += 1) { this._state.scenes[i].locks[slot] = null; }
        return this;
    };
    SceneCore.prototype.setBase = function (values) {
        var next = nulls(SLOT_COUNT), i;
        exactArray(values, SLOT_COUNT, "base");
        for (i = 0; i < SLOT_COUNT; i += 1) {
            if (this._state.mappings[i] !== null) { next[i] = normalized(values[i], false); }
        }
        this._state.base = next;
        return this;
    };
    SceneCore.prototype.setLock = function (scene, slot, value) {
        index(scene, SCENE_COUNT, "scene");
        index(slot, SLOT_COUNT, "slot");
        if (this._state.mappings[slot] === null) { fail("cannot lock an unmapped slot"); }
        this._state.scenes[scene].locks[slot] = normalized(value, false);
        return this;
    };
    SceneCore.prototype.clearLock = function (scene, slot) {
        index(scene, SCENE_COUNT, "scene");
        index(slot, SLOT_COUNT, "slot");
        this._state.scenes[scene].locks[slot] = null;
        return this;
    };
    SceneCore.prototype.clearScene = function (scene) {
        index(scene, SCENE_COUNT, "scene");
        this._state.scenes[scene].locks = nulls(SLOT_COUNT);
        return this;
    };
    SceneCore.prototype.copyScene = function (from, to) {
        index(from, SCENE_COUNT, "source scene");
        index(to, SCENE_COUNT, "destination scene");
        this._state.scenes[to] = copyScene(this._state.scenes[from]);
        return this;
    };
    SceneCore.prototype.renameScene = function (scene, name) {
        index(scene, SCENE_COUNT, "scene");
        this._state.scenes[scene].name = text(name, 64, "scene name");
        return this;
    };
    SceneCore.prototype.getMapping = function (slot) {
        index(slot, SLOT_COUNT, "slot");
        return copyMapping(this._state.mappings[slot]);
    };
    SceneCore.prototype.getMappings = function () {
        var result = [], i;
        for (i = 0; i < SLOT_COUNT; i += 1) { result.push(copyMapping(this._state.mappings[i])); }
        return result;
    };
    SceneCore.prototype.getScene = function (scene) {
        index(scene, SCENE_COUNT, "scene");
        return copyScene(this._state.scenes[scene]);
    };
    SceneCore.prototype.getBase = function () { return this._state.base.slice(0); };
    SceneCore.prototype.evaluateDirect = function (scene) {
        var result = nulls(SLOT_COUNT), locks, meta, i;
        index(scene, SCENE_COUNT, "scene");
        locks = this._state.scenes[scene].locks;
        for (i = 0; i < SLOT_COUNT; i += 1) {
            meta = this._state.mappings[i];
            if (meta !== null) {
                result[i] = quantize(locks[i] === null ? this._state.base[i] : locks[i], meta);
            }
        }
        return result;
    };
    SceneCore.prototype.evaluateMorph = function (a, b, x) {
        var result = nulls(SLOT_COUNT), left, right, meta, vA, vB, i;
        index(a, SCENE_COUNT, "scene A");
        index(b, SCENE_COUNT, "scene B");
        x = normalized(x, false);
        left = this._state.scenes[a].locks;
        right = this._state.scenes[b].locks;
        for (i = 0; i < SLOT_COUNT; i += 1) {
            meta = this._state.mappings[i];
            if (meta !== null && (left[i] !== null || right[i] !== null)) {
                vA = left[i] === null ? this._state.base[i] : left[i];
                vB = right[i] === null ? this._state.base[i] : right[i];
                result[i] = quantize(vA + x * (vB - vA), meta);
            }
        }
        return result;
    };
    SceneCore.prototype.exportState = function () {
        var result = { schemaVersion: SCHEMA_VERSION, mappings: this.getMappings(), base: this.getBase(), scenes: [] }, i;
        for (i = 0; i < SCENE_COUNT; i += 1) { result.scenes.push(this.getScene(i)); }
        return result;
    };
    SceneCore.prototype.serialize = function () { return JSON.stringify(this.exportState()); };
    SceneCore.prototype.importState = function (state) {
        if (typeof state === "string") {
            try { state = JSON.parse(state); } catch (e) { fail("invalid state JSON"); }
        }
        this._state = validateState(state);
        return this;
    };

    return SceneCore;
}));
