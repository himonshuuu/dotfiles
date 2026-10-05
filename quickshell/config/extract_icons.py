#!/usr/bin/env python3

import gi
import json
import glob
import os

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

DESKTOP_DIR = "/usr/share/applications"
OUTPUT = ".config/quickshell/config/icon_map.json"

icon_theme = Gtk.IconTheme.get_default()
results = []

def get_icon_path(icon_name):
    try:
        info = icon_theme.lookup_icon(icon_name, 256, 0)
        if info:
            return info.get_filename()
    except:
        pass
    return None

for desktop in glob.glob(f"{DESKTOP_DIR}/*.desktop"):
    try:
        with open(desktop, "r", errors="ignore") as f:
            lines = f.readlines()
    except Exception:
        continue

    icon = None
    keywords = set()

    for line in lines:
        line = line.strip()
        if line.startswith("Icon="):
            icon = line.split("=", 1)[1]
            keywords.add(icon)
        elif line.startswith("Name="):
            keywords.add(line.split("=", 1)[1])
        elif line.startswith("GenericName="):
            keywords.add(line.split("=", 1)[1])
        elif line.startswith("StartupWMClass="):
            keywords.add(line.split("=", 1)[1])
        elif line.startswith("Exec="):
            keywords.add(line.split("=", 1)[1])

    if not icon:
        continue

    path = get_icon_path(icon)

    if path:
        results.append({
            "keywords": sorted(list(keywords)),
            "image": path
        })
    else:
        print(f"❌ Missing icon for: {icon}")

with open(OUTPUT, "w") as f:
    json.dump(results, f, indent=2)

print(f"✅ Done. Icons found: {len(results)}")
print(f"JSON saved to: {OUTPUT}")
