#!/usr/bin/env python3
"""Simple GDScript validator: checks balanced brackets in .gd files.

This is a lightweight smoke-test — it does NOT parse GDScript fully.
Run: python3 tools/validate_gd_scripts.py
"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(__file__))

def check_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        s = f.read()
    pairs = [('(', ')'), ('[', ']'), ('{', '}')]
    ok = True
    for a,b in pairs:
        ca = s.count(a)
        cb = s.count(b)
        if ca != cb:
            print(f"UNBALANCED {a}{b} in {path}: {ca} vs {cb}")
            ok = False
    return ok

def main():
    all_ok = True
    for dirpath, dirnames, filenames in os.walk(ROOT):
        for fn in filenames:
            if fn.endswith('.gd'):
                p = os.path.join(dirpath, fn)
                ok = check_file(p)
                all_ok = all_ok and ok
    if not all_ok:
        print('\nValidation failed: see messages above')
        sys.exit(2)
    print('Validation passed: basic bracket counts OK for .gd files')

if __name__ == '__main__':
    main()
