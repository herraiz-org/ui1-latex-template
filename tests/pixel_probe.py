#!/usr/bin/env python3
# Copyright 2026 Israel Herraiz <isra@herraiz.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.

"""Inspect the colors of a binary PPM file, as written by `pdftoppm`.

Usage:
  pixel_probe.py pixel FILE.ppm X Y
      Print the RGB value of one pixel, e.g. "228 0 79".

  pixel_probe.py count FILE.ppm X0 Y0 X1 Y1 R G B [TOLERANCE]
      Print how many pixels of the rectangle (X0,Y0)-(X1,Y1) are within
      TOLERANCE (default 40) of the color R G B.

All coordinates are fractions in [0, 1] measured from the top-left corner.
Using PPM keeps slide colors assertable without an image library.
"""

import sys


def read_ppm(path):
    """Return (width, height, pixel_bytes) for a binary (P6) PPM file."""
    with open(path, "rb") as handle:
        data = handle.read()

    fields = []
    offset = 0
    while len(fields) < 4:
        while data[offset:offset + 1].isspace():
            offset += 1
        if data[offset:offset + 1] == b"#":
            while data[offset:offset + 1] not in (b"\n", b""):
                offset += 1
            continue
        start = offset
        while not data[offset:offset + 1].isspace():
            offset += 1
        fields.append(data[start:offset])

    if fields[0] != b"P6":
        raise SystemExit("not a binary PPM file: %s" % path)
    width, height, maxval = (int(field) for field in fields[1:])
    if maxval != 255:
        raise SystemExit("unsupported maxval %d" % maxval)
    return width, height, data[offset + 1:]


def pixel(path, x_fraction, y_fraction):
    width, height, pixels = read_ppm(path)
    x = min(int(width * x_fraction), width - 1)
    y = min(int(height * y_fraction), height - 1)
    start = (y * width + x) * 3
    print(" ".join(str(value) for value in pixels[start:start + 3]))


def count(path, box, color, tolerance):
    width, height, pixels = read_ppm(path)
    x0, y0, x1, y1 = box
    red, green, blue = color
    matches = 0
    for y in range(int(height * y0), min(int(height * y1), height)):
        row = y * width
        for x in range(int(width * x0), min(int(width * x1), width)):
            start = (row + x) * 3
            if (abs(pixels[start] - red) <= tolerance
                    and abs(pixels[start + 1] - green) <= tolerance
                    and abs(pixels[start + 2] - blue) <= tolerance):
                matches += 1
    print(matches)


def main():
    args = sys.argv[1:]
    if len(args) == 4 and args[0] == "pixel":
        pixel(args[1], float(args[2]), float(args[3]))
    elif args[:1] == ["count"] and len(args) in (9, 10):
        box = [float(value) for value in args[2:6]]
        color = [int(value) for value in args[6:9]]
        tolerance = int(args[9]) if len(args) == 10 else 40
        count(args[1], box, color, tolerance)
    else:
        raise SystemExit(__doc__)


if __name__ == "__main__":
    main()
