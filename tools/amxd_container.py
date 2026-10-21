"""Independent writer for the AMXD layout evidenced by Ableton/maxdevtools.

This constructs the container; it does not claim to validate a Max patch's runtime.
No third-party Python dependencies. Public-domain implementation for this task.
"""
from __future__ import annotations

import json
import struct
from dataclasses import dataclass


@dataclass(frozen=True)
class Entry:
    name: str
    data: bytes
    kind: bytes = b"TEXT"
    flags: int = 0
    version: int = 0
    # 2026-01-01 in HFS epoch seconds; deterministic and valid on all platforms.
    modified: int = 3850070400


def _be_chunk(tag: bytes, data: bytes) -> bytes:
    assert len(tag) == 4
    return tag + struct.pack(">I", len(data) + 8) + data


def _le_chunk(tag: bytes, data: bytes) -> bytes:
    assert len(tag) == 4
    return tag + struct.pack("<I", len(data)) + data


def _uint(tag: bytes, value: int) -> bytes:
    return _be_chunk(tag, struct.pack(">I", value))


def frozen_amxd(entries: list[Entry], device_type: bytes = b"aaaa") -> bytes:
    """Build a frozen device. First entry must be its main patcher JSON.

    Example: frozen_amxd([
        Entry("OctaScenes.amxd", json.dumps(patch).encode()+b"\n\0", b"JSON", 17),
        Entry("octascenes.js", source.encode(), b"TEXT"),
    ])
    """
    if not entries or entries[0].kind != b"JSON" or entries[0].flags != 17:
        raise ValueError("first entry must be main JSON patcher with flags=17")
    if len(set(e.name for e in entries)) != len(entries):
        raise ValueError("duplicate filenames")
    if device_type not in (b"aaaa", b"mmmm", b"iiii"):
        raise ValueError("unsupported device type")
    data = bytearray()
    directory = bytearray()
    for e in entries:
        if len(e.kind) != 4 or "\0" in e.name:
            raise ValueError("invalid entry kind/name")
        name = e.name.encode("ascii") + b"\0"
        name += b"\0" * (-len(name) % 4)
        fields = b"".join([
            _be_chunk(b"type", e.kind),
            _be_chunk(b"fnam", name),
            _uint(b"sz32", len(e.data)),
            _uint(b"of32", len(data) + 16),
            _uint(b"vers", e.version),
            _uint(b"flag", e.flags),
            _uint(b"mdat", e.modified),
        ])
        directory.extend(_be_chunk(b"dire", fields))
        data.extend(e.data)
    payload = b"mx@c" + struct.pack(">IQ", 16, len(data) + 16)
    payload += data + _be_chunk(b"dlst", directory)
    return b"".join([
        _le_chunk(b"ampf", device_type),
        _le_chunk(b"meta", struct.pack("<I", 7)),
        _le_chunk(b"ptch", payload),
    ])


def unpack_frozen(blob: bytes) -> tuple[bytes, list[Entry]]:
    """Strict structural parser, useful for packaging tests/byte comparisons."""
    chunks = {}
    pos = 0
    while pos < len(blob):
        if pos + 8 > len(blob):
            raise ValueError("truncated chunk header")
        tag = blob[pos:pos+4]
        size = struct.unpack_from("<I", blob, pos+4)[0]
        pos += 8
        if tag in chunks or pos + size > len(blob):
            raise ValueError("duplicate/truncated chunk")
        chunks[tag] = blob[pos:pos+size]
        pos += size
    if list(chunks) != [b"ampf", b"meta", b"ptch"]:
        raise ValueError("unexpected outer chunks")
    p = chunks[b"ptch"]
    if p[:8] != b"mx@c\0\0\0\x10":
        raise ValueError("bad frozen header")
    footer = struct.unpack_from(">Q", p, 8)[0]
    if not 16 <= footer <= len(p)-8 or p[footer:footer+4] != b"dlst":
        raise ValueError("bad directory offset")
    if struct.unpack_from(">I", p, footer+4)[0] != len(p)-footer:
        raise ValueError("bad directory size")
    pos = footer + 8
    result = []
    expected_data = 16
    while pos < len(p):
        if p[pos:pos+4] != b"dire":
            raise ValueError("bad directory entry")
        end = pos + struct.unpack_from(">I", p, pos+4)[0]
        if end > len(p) or end < pos + 8:
            raise ValueError("bad entry size")
        pos += 8
        fields = {}
        while pos < end:
            tag = p[pos:pos+4]
            size = struct.unpack_from(">I", p, pos+4)[0]
            if size < 8 or pos + size > end or tag in fields:
                raise ValueError("bad field size/duplicate")
            fields[tag] = p[pos+8:pos+size]
            pos += size
        uint = lambda t: struct.unpack(">I", fields[t])[0]
        offset, size = uint(b"of32"), uint(b"sz32")
        if offset != expected_data or offset + size > footer:
            raise ValueError("non-contiguous/overlapping/out-of-bounds data")
        expected_data = offset + size
        result.append(Entry(
            fields[b"fnam"].rstrip(b"\0").decode("ascii"),
            p[offset:offset+size], fields[b"type"],
            uint(b"flag"), uint(b"vers"), uint(b"mdat"),
        ))
    if expected_data != footer:
        raise ValueError("unreferenced payload bytes")
    return chunks[b"ampf"], result


if __name__ == "__main__":
    from pathlib import Path
    base = Path(__file__).parent
    fixture = base / "maxdevtools/maxdiff/tests/test_files/FrozenTest.amxd"
    blob = fixture.read_bytes()
    device_type, entries = unpack_frozen(blob)
    rebuilt = frozen_amxd(entries, device_type)
    assert rebuilt == blob, "official fixture does not round-trip exactly"
    print(f"PASS: official FrozenTest.amxd round-trips byte-for-byte ({len(blob)} bytes, {len(entries)} entries)")
    minimal = {"patcher": {"fileversion": 1, "boxes": [], "lines": []}}
    test = frozen_amxd([
        Entry("Minimal.amxd", json.dumps(minimal).encode()+b"\n\0", b"JSON", 17),
        Entry("logic.js", b"autowatch = 0;\n"),
    ])
    kind, restored = unpack_frozen(test)
    assert kind == b"aaaa" and restored[1].data == b"autowatch = 0;\n"
    (base / "Minimal.amxd").write_bytes(test)
    print("PASS: minimal audio container and bundled JavaScript unpack correctly")
