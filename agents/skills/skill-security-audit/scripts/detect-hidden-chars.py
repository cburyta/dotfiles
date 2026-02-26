#!/usr/bin/env python3
"""Scan files for hidden Unicode characters that could conceal prompt injections or malicious content."""
import os
import sys

ZERO_WIDTH = {
    b'\xe2\x80\x8b': 'ZERO WIDTH SPACE (U+200B)',
    b'\xe2\x80\x8c': 'ZERO WIDTH NON-JOINER (U+200C)',
    b'\xe2\x80\x8d': 'ZERO WIDTH JOINER (U+200D)',
    b'\xe2\x80\x8e': 'LEFT-TO-RIGHT MARK (U+200E)',
    b'\xe2\x80\x8f': 'RIGHT-TO-LEFT MARK (U+200F)',
    b'\xe2\x80\xaa': 'LEFT-TO-RIGHT EMBEDDING (U+202A)',
    b'\xe2\x80\xab': 'RIGHT-TO-LEFT EMBEDDING (U+202B)',
    b'\xe2\x80\xac': 'POP DIRECTIONAL FORMATTING (U+202C)',
    b'\xe2\x80\xad': 'LEFT-TO-RIGHT OVERRIDE (U+202D)',
    b'\xe2\x80\xae': 'RIGHT-TO-LEFT OVERRIDE (U+202E)',
    b'\xe2\x81\xa0': 'WORD JOINER (U+2060)',
    b'\xe2\x81\xa1': 'FUNCTION APPLICATION (U+2061)',
    b'\xe2\x81\xa2': 'INVISIBLE TIMES (U+2062)',
    b'\xe2\x81\xa3': 'INVISIBLE SEPARATOR (U+2063)',
    b'\xe2\x81\xa4': 'INVISIBLE PLUS (U+2064)',
    b'\xef\xbf\xb9': 'INTERLINEAR ANNOTATION ANCHOR (U+FFF9)',
    b'\xef\xbf\xba': 'INTERLINEAR ANNOTATION SEPARATOR (U+FFFA)',
    b'\xef\xbf\xbb': 'INTERLINEAR ANNOTATION TERMINATOR (U+FFFB)',
    b'\xc2\xad':     'SOFT HYPHEN (U+00AD)',
}

TAG_RANGE_START = 0xE0001
TAG_RANGE_END = 0xE007F

SKIP_DIRS = {'.git', 'node_modules', '.venv', '__pycache__', '.tox', 'vendor'}
BINARY_EXT = {'.png', '.jpg', '.jpeg', '.gif', '.ico', '.woff', '.woff2', '.ttf',
              '.eot', '.mp3', '.mp4', '.zip', '.gz', '.tar', '.pdf', '.exe', '.bin',
              '.so', '.dylib', '.dll', '.class', '.o', '.pyc'}


def scan_file(filepath: str) -> list[dict]:
    findings = []
    try:
        data = open(filepath, 'rb').read()
    except (OSError, PermissionError):
        return findings

    if b'\xef\xbb\xbf' == data[:3]:
        findings.append({'file': filepath, 'byte': 0, 'line': 1, 'char': 'BOM (U+FEFF)',
                         'severity': 'LOW', 'context': data[:40].decode('utf-8', errors='replace')})

    line_num = 1
    i = 0
    while i < len(data):
        if data[i] == 0x0a:
            line_num += 1
            i += 1
            continue

        # Control characters (excluding tab, newline, carriage return)
        if data[i] < 0x09 or (0x0e <= data[i] <= 0x1f) or data[i] == 0x7f:
            start = max(0, i - 15)
            end = min(len(data), i + 15)
            findings.append({
                'file': filepath, 'byte': i, 'line': line_num,
                'char': f'CONTROL CHAR (0x{data[i]:02x})',
                'severity': 'HIGH',
                'context': data[start:end].decode('utf-8', errors='replace'),
            })
            i += 1
            continue

        # Multi-byte zero-width / bidi characters
        if data[i] == 0xe2 and i + 2 < len(data):
            seq = data[i:i+3]
            if seq in ZERO_WIDTH:
                start = max(0, i - 15)
                end = min(len(data), i + 18)
                findings.append({
                    'file': filepath, 'byte': i, 'line': line_num,
                    'char': ZERO_WIDTH[seq],
                    'severity': 'CRITICAL' if 'OVERRIDE' in ZERO_WIDTH[seq] or 'EMBEDDING' in ZERO_WIDTH[seq] else 'HIGH',
                    'context': data[start:end].decode('utf-8', errors='replace'),
                })
                i += 3
                continue

        # Soft hyphen
        if data[i] == 0xc2 and i + 1 < len(data):
            seq = data[i:i+2]
            if seq in ZERO_WIDTH:
                findings.append({
                    'file': filepath, 'byte': i, 'line': line_num,
                    'char': ZERO_WIDTH[seq],
                    'severity': 'MEDIUM',
                    'context': '',
                })
                i += 2
                continue

        # Interlinear annotation chars
        if data[i] == 0xef and i + 2 < len(data):
            seq = data[i:i+3]
            if seq in ZERO_WIDTH:
                findings.append({
                    'file': filepath, 'byte': i, 'line': line_num,
                    'char': ZERO_WIDTH[seq],
                    'severity': 'CRITICAL',
                    'context': '',
                })
                i += 3
                continue

        # Unicode tag characters (U+E0001–U+E007F) — used in tag-based exploits
        if data[i] == 0xf3 and i + 3 < len(data):
            cp = int.from_bytes(data[i:i+4], 'big')
            if TAG_RANGE_START <= cp <= TAG_RANGE_END:
                findings.append({
                    'file': filepath, 'byte': i, 'line': line_num,
                    'char': f'UNICODE TAG (U+{cp:05X})',
                    'severity': 'CRITICAL',
                    'context': '',
                })
                i += 4
                continue

        i += 1

    return findings


def scan_directory(target: str) -> list[dict]:
    all_findings = []
    for root, dirs, files in os.walk(target):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for f in files:
            if os.path.splitext(f)[1].lower() in BINARY_EXT:
                continue
            path = os.path.join(root, f)
            if os.path.getsize(path) > 5 * 1024 * 1024:
                continue
            all_findings.extend(scan_file(path))
    return all_findings


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <directory|file>", file=sys.stderr)
        sys.exit(1)

    target = sys.argv[1]
    if os.path.isfile(target):
        findings = scan_file(target)
    elif os.path.isdir(target):
        findings = scan_directory(target)
    else:
        print(f"Error: {target} not found", file=sys.stderr)
        sys.exit(1)

    if not findings:
        print("No hidden characters found.")
        sys.exit(0)

    severity_order = {'CRITICAL': 0, 'HIGH': 1, 'MEDIUM': 2, 'LOW': 3}
    findings.sort(key=lambda f: severity_order.get(f['severity'], 99))

    for f in findings:
        ctx = f' | context: {f["context"]!r}' if f.get('context') else ''
        print(f'[{f["severity"]}] {f["file"]}:{f["line"]} (byte {f["byte"]}) — {f["char"]}{ctx}')

    crits = sum(1 for f in findings if f['severity'] == 'CRITICAL')
    highs = sum(1 for f in findings if f['severity'] == 'HIGH')
    print(f'\nTotal: {len(findings)} findings ({crits} critical, {highs} high)')
    sys.exit(1 if crits > 0 else 0)


if __name__ == '__main__':
    main()
