# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains Advent of Code solutions spanning from 2015 to 2024, utilizing multiple tools and languages:
- **SQL solutions**: Written for DuckDB, using creative SQL techniques with CTEs, window functions, and string manipulation
- **Excel solutions**: Implemented as spreadsheet formulas (.xlsx and .xlsm files)

## File Organization

Solutions are organized by year (2015-2024) with each day's solution in its respective directory:
- SQL files: `dayN.sql` format
- Excel files: `Day N.xlsx` or `Day N.xlsm` format

## SQL Solution Architecture

SQL solutions follow a consistent pattern:
1. **Input handling**: Use `set variable` to define puzzle input, then parse with `regexp_split_to_table()`
2. **Recursive CTEs**: Complex parsing and traversal logic (e.g., character-by-character processing in 2015/day1.sql)
3. **Window functions**: Sliding window operations for pattern matching (e.g., 2024/day4.sql uses `ROWS 3 PRECEDING` for XMAS detection)
4. **Dual solutions**: Both Part 1 and Part 2 solutions in single file using UNION queries

### Key SQL Patterns Used

- **Character processing**: `string_split()` and `substring()` for character-level manipulation  
- **Grid operations**: `generate_subscripts()` and `unnest()` for 2D grid traversal
- **Pattern matching**: `SIMILAR TO` regex patterns for complex matching
- **Position tracking**: Diagonal calculations using `idx - idy` and `idx + idy` formulas

## Running Solutions

**SQL files**: Execute directly in DuckDB CLI or compatible SQL environment
**Excel files**: Open in Microsoft Excel or LibreOffice Calc

No build, lint, or test commands are configured for this repository.