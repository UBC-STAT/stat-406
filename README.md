# STAT 406 — Course Website / Lectures

This repository generates the course website and holds all lecture materials. It
is hosted at <https://github.com/ubc-stat/stat-406> and published to
<https://ubc-stat.github.io/stat-406/>.

For course *infrastructure* setup and management (Canvas, Slack, clickers, R
package, homeworks/labs/exams, etc.), see the README in
[https://github.com/UBC-STAT/stat-406-instructors/](the STAT 406 instructors repo).

## Contents

The entire site and all materials are Quarto (`.qmd`) files.

- `_quarto.yml` — top-level site configuration (navbar, footer, render list, theme).
- `index.qmd`, `syllabus.qmd`, `faq.qmd` — landing page and standalone pages.
- `schedule/index.qmd` — the schedule: module outlines, learning objectives, and
  the date-by-date table linking to every slide deck and lecture note.
- `schedule/slides/` — **the intro material, as Quarto reveal.js slides**
  (`00-intro.qmd`, `00-r-review.qmd`, `00-version-control.qmd`). Slide-specific
  config lives in `_metadata.yml` (reveal.js format), `_config.R`,
  `_titleslide.qmd`, `themer.scss`, and `tachyons-minimal.css`.
- `schedule/lectures/` — **the rest of the lectures, as Quarto notes**
  (`lecture_01_*.qmd` … `lecture_20_*.qmd`), rendered to HTML. Format config is in
  that folder's `_metadata.yml`.
- `schedule/Rcode/` — standalone `R` code for the lectures.
- `schedule/notebooks/` — Jupyter notebooks that generate lecture figures into
  `schedule/figures/`. Not rendered as part of the site; run manually to
  regenerate plots.
- `schedule/handouts/` — supplementary handouts (programming, RMarkdown, git lab).
- `computing/` — platform-specific setup instructions
  (`mac_arm.qmd`, `mac_x86.qmd`, `ubuntu.qmd`, `windows.qmd`).
- `assets/` — shared styles (`styles.scss`, `index.css`) and images.
- `_freeze/` — cached results of executed `R` chunks (see below). **Checked in.**

Some notes:

- `_quarto.yml` contains the configuration for the site.
- `schedule/slides/_metadata.yml` contains configuration for the slides;
  `schedule/lectures/_metadata.yml` for the lecture notes.
- Installing the course package should install all necessary packages to render
  the site. But some may be missing.

## Updating the website

The site is configured following
<https://quarto.org/docs/publishing/github-pages.html#publish-action>. Deployment
is automatic:

1. **Push to `main` on GitHub.** The `Quarto Publish` GitHub Action
   (`.github/workflows/publish.yml`) renders the site and pushes the compiled
   output to the `gh-pages` branch, which is what gets served.
2. **All `R` code must be run *before* pushing.** The site uses
   `execute: freeze: auto`, so the Action does **not** run `R` — it reuses the
   cached chunk output in `_freeze/`. This avoids needing an `renv` setup in the
   Action. **Commit any changes to the `_freeze/` files** whenever you edit code
   in a `.qmd`, or the published site won't reflect your changes.

### Debugging

If the website doesn't update after a push:

- **Check whether the build Action failed** (repo → Actions tab).
- If it failed, **run `quarto render` locally** and look for the errors there.
- If it renders successfully locally, **commit any updated `_freeze/` files** and
  push again to re-trigger the build.
