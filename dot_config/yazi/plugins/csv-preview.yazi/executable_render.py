#!/usr/bin/env python3

import csv
import sys
from pathlib import Path


MAX_ROWS = 30
MAX_COLUMNS = 8
MIN_COLUMN_WIDTH = 3
MAX_COLUMN_WIDTH = 32


def clean(value: str) -> str:
    return " ".join(value.split())


def ellipsize(value: str, width: int) -> str:
    if len(value) <= width:
        return value
    if width == 1:
        return "…"
    return value[: width - 1] + "…"


def read_rows(path: Path) -> tuple[list[list[str]] | None, str | None]:
    try:
        with path.open("r", encoding="utf-8-sig", errors="replace", newline="") as handle:
            return [[clean(cell) for cell in row] for row in csv.reader(handle, strict=True)], None
    except (OSError, csv.Error) as error:
        return None, f"(CSV parse error: {error})"


def render(rows: list[list[str]], width: int) -> str:
    if not rows:
        return "(empty CSV)"

    columns = min(MAX_COLUMNS, max(len(row) for row in rows))
    visible = [(row + [""] * columns)[:columns] for row in rows[:MAX_ROWS]]
    available = max(columns * (MIN_COLUMN_WIDTH + 2) + columns + 1, width)
    limit = max(MIN_COLUMN_WIDTH, min(MAX_COLUMN_WIDTH, (available - columns - 1) // columns - 2))
    widths = [min(limit, max(MIN_COLUMN_WIDTH, max(len(row[index]) for row in visible))) for index in range(columns)]

    def divider() -> str:
        return "+" + "+".join("-" * (column + 2) for column in widths) + "+"

    def format_row(row: list[str]) -> str:
        cells = (f" {ellipsize(row[index], widths[index]):<{widths[index]}} " for index in range(columns))
        return "|" + "|".join(cells) + "|"

    output = [divider()]
    for row in visible:
        output.append(format_row(row))
        output.append(divider())
    if len(rows) > MAX_ROWS:
        output.append(f"… {len(rows) - MAX_ROWS} more rows")
    return "\n".join(output)


def main() -> None:
    if len(sys.argv) != 4:
        print("(csv-preview: invalid arguments)")
        return

    rows, error = read_rows(Path(sys.argv[1]))
    if error:
        print(error)
        return

    try:
        width = max(20, int(sys.argv[2]))
        int(sys.argv[3])
    except ValueError:
        print("(csv-preview: invalid preview size)")
        return

    print(render(rows or [], width))


if __name__ == "__main__":
    main()
