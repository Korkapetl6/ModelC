"use strict";

var assert = require("assert");
var fs = require("fs");
var path = require("path");
var vm = require("vm");
var SceneCore = require("../src/scene-core.js");
var passed = 0;

function test(name, fn) {
    try {
        fn();
        passed += 1;
        process.stdout.write("PASS " + name + "\n");
    } catch (error) {
        process.stderr.write("FAIL " + name + "\n");
        throw error;
    }
}
function approx(actual, expected) { assert.ok(Math.abs(actual - expected) < 1e-12, actual + " != " + expected); }
function meta(key, extra) {
    var result = { key: key, label: key, min: 0, max: 1, quantized: false };
    Object.keys(extra || {}).forEach(function (key) { result[key] = extra[key]; });
    return result;
}
function configured() {
    var core = new SceneCore();
    core.setMapping(0, meta("filter"));
    core.setMapping(1, meta("reverb"));
    core.setMapping(2, meta("volume"));
    var base = core.getBase();
    base[0] = 0.8; base[1] = 0.1; base[2] = 0.6;
    core.setBase(base);
    return core;
}
function unchangedOnReject(core, mutate) {
    var before = core.serialize();
    var state = core.exportState();
    mutate(state);
    assert.throws(function () { core.importState(state); }, /OctaScenes/);
    assert.strictEqual(core.serialize(), before);
}

test("blank device has 16 independent sparse scenes and 32 unmapped slots", function () {
    var core = new SceneCore(), state = core.exportState();
    assert.strictEqual(state.scenes.length, 16);
    assert.strictEqual(state.mappings.length, 32);
    assert.strictEqual(state.scenes[0].name, "Scene01");
    assert.strictEqual(state.scenes[15].name, "Scene16");
    assert.ok(core.evaluateDirect(0).every(function (value) { return value === null; }));
});
test("sparse morph uses base for missing endpoint and leaves unlocked targets free", function () {
    var core = configured();
    core.setLock(0, 0, 0.2).setLock(1, 1, 0.9);
    var left = core.evaluateMorph(0, 1, 0), middle = core.evaluateMorph(0, 1, 0.5), right = core.evaluateMorph(0, 1, 1);
    approx(left[0], 0.2); approx(left[1], 0.1);
    approx(middle[0], 0.5); approx(middle[1], 0.5);
    approx(right[0], 0.8); approx(right[1], 0.9);
    assert.strictEqual(middle[2], null);
    assert.strictEqual(middle[31], null);
});
test("direct switching explicitly restores prior scene-only values to base", function () {
    var core = configured();
    core.setLock(0, 0, 0.2).setLock(1, 1, 0.9);
    assert.deepStrictEqual(core.evaluateDirect(0).slice(0, 3), [0.2, 0.1, 0.6]);
    assert.deepStrictEqual(core.evaluateDirect(1).slice(0, 3), [0.8, 0.9, 0.6]);
    assert.deepStrictEqual(core.evaluateDirect(2).slice(0, 3), [0.8, 0.1, 0.6]);
});
test("both endpoints, zero locks, identical scenes, and changing shared base", function () {
    var core = configured();
    core.setLock(0, 0, 0).setLock(1, 0, 1);
    approx(core.evaluateMorph(0, 1, 0.25)[0], 0.25);
    assert.strictEqual(core.evaluateMorph(0, 0, 0.6)[0], 0);
    core.clearLock(1, 0);
    var base = core.getBase(); base[0] = 0.4; core.setBase(base);
    approx(core.evaluateMorph(0, 1, 0.5)[0], 0.2);
});
test("quantized parameters round in actual Live units, including nonzero min", function () {
    var core = new SceneCore();
    core.setMapping(0, meta("enum", { min: 2, max: 6, quantized: true, steps: 5 }));
    core.setMapping(1, meta("switch", { min: 0, max: 1, quantized: true }));
    core.setLock(0, 0, 0).setLock(1, 0, 1).setLock(0, 1, 0).setLock(1, 1, 1);
    assert.strictEqual(core.evaluateMorph(0, 1, 0.36)[0], 0.25);
    assert.strictEqual(core.evaluateMorph(0, 1, 0.38)[0], 0.5);
    assert.strictEqual(core.evaluateMorph(0, 1, 0.49)[1], 0);
    assert.strictEqual(core.evaluateMorph(0, 1, 0.5)[1], 1);
    core.setLock(0, 0, 0.38);
    assert.strictEqual(core.evaluateDirect(0)[0], 0.5);
});
test("same mapping preserves locks/base; new target clears every stale lock", function () {
    var core = configured();
    core.setLock(0, 0, 0.2).setLock(15, 0, 0.9);
    core.setMapping(0, meta("filter", { label: "Renamed Filter" }));
    assert.strictEqual(core.getBase()[0], 0.8);
    assert.strictEqual(core.getScene(0).locks[0], 0.2);
    core.setMapping(0, meta("different-filter"));
    assert.strictEqual(core.getBase()[0], 0);
    assert.strictEqual(core.getScene(0).locks[0], null);
    assert.strictEqual(core.getScene(15).locks[0], null);
    assert.strictEqual(core.getMapping(0).key, "different-filter");
    assert.throws(function () { core.setMapping(3, meta("reverb")); }, /already mapped/);
    assert.strictEqual(core.getMapping(3), null);
});
test("unmapping releases a slot and removes its base and all locks", function () {
    var core = configured();
    core.setLock(0, 0, 0.2).setLock(15, 0, 0.9).unmap(0);
    assert.strictEqual(core.getMapping(0), null);
    assert.strictEqual(core.getBase()[0], null);
    assert.strictEqual(core.getScene(0).locks[0], null);
    assert.strictEqual(core.getScene(15).locks[0], null);
    assert.strictEqual(core.evaluateDirect(0)[0], null);
    assert.throws(function () { core.setLock(0, 0, 0.2); }, /unmapped/);
});
test("copy creates independent locks and name; clear keeps the scene name", function () {
    var core = configured();
    core.renameScene(0, "Dub").setLock(0, 0, 0.2).copyScene(0, 1);
    core.renameScene(0, "Space").setLock(0, 0, 0.7);
    assert.strictEqual(core.getScene(1).name, "Dub");
    assert.strictEqual(core.getScene(1).locks[0], 0.2);
    core.clearScene(1);
    assert.strictEqual(core.getScene(1).name, "Dub");
    assert.strictEqual(core.getScene(1).locks[0], null);
    assert.strictEqual(core.getScene(0).locks[0], 0.7);
});
test("setter values clamp; invalid base update and invalid mapping are atomic", function () {
    var core = configured(), base = core.getBase();
    core.setLock(0, 0, -7).setLock(0, 1, 9);
    assert.strictEqual(core.getScene(0).locks[0], 0);
    assert.strictEqual(core.getScene(0).locks[1], 1);
    base[0] = -2; base[1] = 3; core.setBase(base);
    assert.strictEqual(core.getBase()[0], 0); assert.strictEqual(core.getBase()[1], 1);
    assert.strictEqual(core.evaluateMorph(0, 1, -4)[1], 1);
    var before = core.serialize();
    base[0] = 0.4; base[1] = Infinity;
    assert.throws(function () { core.setBase(base); });
    assert.throws(function () { core.setMapping(0, meta("bad", { min: 1, max: 1 })); });
    assert.strictEqual(core.serialize(), before);
    [NaN, Infinity, "0.5", null].forEach(function (value) {
        assert.throws(function () { core.setLock(0, 0, value); });
        assert.throws(function () { core.evaluateMorph(0, 1, value); });
    });
});
test("persistence roundtrip retains performance and strips runtime IDs at mapping", function () {
    var core = configured();
    core.setMapping(3, meta("live_set tracks 0 devices 0 parameters 3", { id: 9812, liveId: 9812 }));
    core.renameScene(1, "Dub / Żółć").setLock(1, 3, 0.7).setLock(0, 1, 0.2);
    var restored = new SceneCore(core.serialize());
    assert.deepStrictEqual(restored.exportState(), core.exportState());
    assert.deepStrictEqual(restored.evaluateMorph(0, 1, 0.3), core.evaluateMorph(0, 1, 0.3));
    assert.strictEqual(core.serialize().indexOf("9812"), -1);
});
test("exported/getter state cannot mutate engine internals", function () {
    var core = configured(), state = core.exportState(), scene = core.getScene(0), base = core.getBase(), mapping = core.getMapping(0);
    state.base[0] = 0; state.mappings[0].key = "evil"; scene.locks[0] = 1; base[1] = 1; mapping.label = "changed";
    assert.strictEqual(core.getBase()[0], 0.8);
    assert.strictEqual(core.getMapping(0).key, "filter");
    assert.strictEqual(core.getScene(0).locks[0], null);
    assert.strictEqual(core.getBase()[1], 0.1);
    assert.strictEqual(core.getMapping(0).label, "filter");
});
test("invalid saved state is rejected without partial mutation", function () {
    var core = configured();
    core.renameScene(4, "Keep").setLock(4, 0, 0.3);
    [
        function (s) { s.schemaVersion = 999; },
        function (s) { s.mappings.pop(); },
        function (s) { s.base.pop(); },
        function (s) { s.scenes.pop(); },
        function (s) { s.scenes[15].locks.pop(); },
        function (s) { s.scenes[15].locks[0] = 1.1; },
        function (s) { s.scenes[15].locks[0] = NaN; },
        function (s) { s.base[0] = -0.1; },
        function (s) { s.base[31] = 0.1; },
        function (s) { s.scenes[15].locks[31] = 0.1; },
        function (s) { s.scenes[15].name = ""; },
        function (s) { s.mappings[0].max = s.mappings[0].min; },
        function (s) { s.mappings[0].quantized = 1; },
        function (s) { s.mappings[0].steps = 1.5; },
        function (s) { s.mappings[1].key = s.mappings[0].key; },
        function (s) { s.mappings[0].id = 123; },
        function (s) { delete s.base; },
        function (s) { s.futureField = true; }
    ].forEach(function (mutate) { unchangedOnReject(core, mutate); });
    var before = core.serialize();
    ["{", "null", "[]", "42"].forEach(function (bad) {
        assert.throws(function () { core.importState(bad); });
        assert.strictEqual(core.serialize(), before);
    });
});
test("scene and slot bounds reject negative, fractional, nonnumeric, and overflow", function () {
    var core = configured();
    [-1, 16, 0.5, NaN, "0"].forEach(function (scene) {
        assert.throws(function () { core.evaluateDirect(scene); });
        assert.throws(function () { core.setLock(scene, 0, 0.5); });
        assert.throws(function () { core.copyScene(0, scene); });
    });
    [-1, 32, 0.5, NaN, "0"].forEach(function (slot) {
        assert.throws(function () { core.getMapping(slot); });
        assert.throws(function () { core.setLock(0, slot, 0.5); });
    });
});
test("global Max include export works without CommonJS", function () {
    var context = {};
    vm.runInNewContext(fs.readFileSync(path.join(__dirname, "../src/scene-core.js"), "utf8"), context);
    assert.strictEqual(typeof context.SceneCore, "function");
    assert.strictEqual(new context.SceneCore().getScene(0).name, "Scene01");
});
test("all 16x16 endpoint pairs preserve exact lock/base rules across full bank", function () {
    var core = new SceneCore(), i, j, a, b, x, value, expected, left, right;
    for (i = 0; i < 32; i += 1) { core.setMapping(i, meta("target-" + i)); }
    var base = core.getBase();
    for (i = 0; i < 32; i += 1) { base[i] = i / 31; }
    core.setBase(base);
    for (i = 0; i < 16; i += 1) {
        for (j = 0; j < 32; j += 1) {
            if ((i + j) % 3 === 0) { core.setLock(i, j, ((i * 17 + j * 7) % 101) / 100); }
        }
    }
    for (a = 0; a < 16; a += 1) {
        for (b = 0; b < 16; b += 1) {
            left = core.getScene(a).locks; right = core.getScene(b).locks;
            for (x = 0; x <= 4; x += 1) {
                value = core.evaluateMorph(a, b, x / 4);
                for (i = 0; i < 32; i += 1) {
                    if (left[i] === null && right[i] === null) {
                        assert.strictEqual(value[i], null);
                    } else {
                        expected = (left[i] === null ? base[i] : left[i]) * (1 - x / 4) +
                            (right[i] === null ? base[i] : right[i]) * (x / 4);
                        approx(value[i], expected);
                    }
                }
            }
        }
    }
});

process.stdout.write("\n" + passed + " scene-core tests passed.\n");
