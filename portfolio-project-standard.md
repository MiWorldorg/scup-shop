# Portfolio Project Standard

Use this document to prepare every project for GitHub, LinkedIn, and Wellfound. It has two parts:

- **Part A: README and documentation.** What a recruiter or interviewer reads first.
- **Part B: Technical standard.** How the code is structured, written, tested, and shipped.

Both parts apply to every repo. When the two conflict, the code must be correct first, and the README must describe the code accurately.

---

# PART A: README AND DOCUMENTATION

## A1. Required README Structure

Every project has a `README.md` with these sections, in this order:

```markdown
# [Project Name]

> One sentence: what it is and who it's for.

**Role:** [Solo / Team of N] · **Period:** [Month YYYY – Month YYYY] · **Status:** [Live / Archived / Prototype]

**Links:** [Live demo] · [GitHub repo] · [Video/Screenshots]

[![CI](https://github.com/USER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/USER/REPO/actions)

---

## 1. Problem
What problem does this solve, and for whom? Two to three sentences. Describe the actual need, not "a simple app that...".

## 2. Solution
What was built and what the main features do, in plain language.

## 3. Screenshots / Demo
- ![Screen 1: short caption](docs/images/screen1.png)
- ![Screen 2: short caption](docs/images/screen2.png)

Optional: a short GIF or video of the key flow.

## 4. Architecture
How the pieces fit together, with a diagram if one exists.

```
[Client (Flutter / Web / Device)] <-> [API / Backend] <-> [Database]
                                         |
                                  [Devices / Sensors (if IoT)]
```

- **Frontend / App:** [e.g. Flutter, Dart, Riverpod]
- **Backend / API:** [e.g. Node.js, Firebase, REST, MQTT]
- **Database / Storage:** [e.g. SQLite, Firestore, PostgreSQL]
- **Hardware / Protocols (if any):** [e.g. ESP32, Bluetooth LE, MQTT]
- **Third-party services:** [e.g. Stripe, Google Maps, Firebase Auth]

## 5. Key Decisions & Trade-offs
Two to four decisions and why each was made. Interviewers ask about these most.

- **Decision:** [e.g. MQTT instead of HTTP polling]
  **Why:** [Lower latency and battery use for sensor data]
  **Trade-off:** [Needs a broker and more setup]

## 6. Challenges & How I Solved Them
- **Challenge:** [e.g. Intermittent Bluetooth disconnects]
  **Fix:** [e.g. Reconnect logic with exponential backoff]

## 7. What I'd Improve Next
Two or three specific, honest items.

## 8. Tech Stack
`Flutter` `Dart` `Firebase` `MQTT` `ESP32` (replace with the actual stack)

## 9. Getting Started
```bash
git clone [repo-url]
cd [project-folder]
[install command]
[run command]
[test command]
```

Required environment variables, hardware setup steps, and wiring pin map go here or link to `docs/`.

## 10. Project Structure
A short tree of the main folders, with one line on what each holds.

## 11. What I Learned
One or two sentences naming a specific skill.

## License
[MIT](LICENSE)
```

## A2. Documentation Rules

- Every README claim must match the code. If a feature isn't built, don't list it.
- Keep `docs/architecture.md` in sync with the real structure. Outdated docs are worse than none.
- Public classes and functions get a short doc comment saying what they do and any non-obvious behavior. Comment why, not what.
- No API keys, passwords, Wi-Fi credentials, or personal data in the README or any file.

## A3. Social Post Snippet (LinkedIn / Wellfound)

```
Title: [Project Name] – [short benefit]

Short description (under 280 characters):
[What it is, the main tech, and the result or what you learned.]

Skills: [Skill 1], [Skill 2], [Skill 3]
```

---

# PART B: TECHNICAL STANDARD

## B1. Repository Layout

```
project-name/
├── README.md              # Per Part A
├── LICENSE                # MIT unless there's a reason not to
├── .gitignore             # Language and IDE specific
├── .env.example           # Required env vars, placeholder values only
├── docs/
│   ├── architecture.md
│   └── images/
├── src/  (or lib/ for Flutter)
├── test/  (or tests/)
├── scripts/               # Setup, seed, flash, deploy helpers (optional)
└── .github/
    └── workflows/ci.yml
```

Rules:
- No build artifacts committed: `node_modules`, `.dart_tool`, `build/`, `.venv`, `__pycache__`.
- No `.env` committed. Only `.env.example`.
- One commit per logical change.

## B2. Naming Conventions

| Thing | Dart / Flutter | TypeScript / Node | Python | C / C++ (ESP32) |
|---|---|---|---|---|
| Files | `snake_case.dart` | `kebab-case.ts` or `camelCase.ts` | `snake_case.py` | `snake_case.cpp` |
| Classes / types | `PascalCase` | `PascalCase` | `PascalCase` | `PascalCase` |
| Functions / variables | `camelCase` | `camelCase` | `snake_case` | `snake_case` |
| Constants | `kDefaultTimeout` | `DEFAULT_TIMEOUT` | `DEFAULT_TIMEOUT` | `DEFAULT_TIMEOUT` |
| Private members | `_privateName` | `private` keyword | `_leading_underscore` | `static` or file scope |

Names describe purpose, not implementation. `sensorReadings` beats `dataArr`. Avoid abbreviations except standard ones (`id`, `url`, `mqtt`).

## B3. Code Structure

**Layers.** Keep these separate:
- **UI:** widgets, screens, or pages. No direct network, database, or device calls.
- **Services / repositories:** API, database, MQTT, and device communication.
- **Models:** plain data classes. Parsing and serialization only.

**Functions do one thing.** If a function needs a comment to explain what it does, split or rename it. Aim for under about 40 lines.

**No magic values.** Timeouts, URLs, topic names, pin numbers, and thresholds go in named constants or a config file.

**Errors are explicit.** Never swallow exceptions silently. Log them, return a meaningful result, or show the user what went wrong.

**No debug leftovers.** Use the project logger, not `print` or `console.log`. No commented-out code, dead code, or unused imports.

## B4. Flutter Rules

- **State management:** one approach per project (Provider, Riverpod, or Bloc). Name it in the README.
- **Widgets:** use `const` constructors. Extract a widget into its own file when it's reused or exceeds about 80 lines.
- **Async:** check `mounted` before using `context` after an `await`.
- **Theming:** colors and text styles live in a theme file. No hardcoded hex values inside widgets.
- **Assets:** in `assets/`, declared in `pubspec.yaml`.
- **Lints:** `flutter_lints` or `very_good_analysis`. `flutter analyze` reports zero issues.
- **Formatting:** `dart format .` before each commit.

## B5. IoT and Embedded Rules

**Firmware (ESP32, Arduino, MicroPython):**
- Keep the main loop non-blocking. Use timers or state machines, not `delay()`.
- Wrap Wi-Fi and MQTT connections in reconnect logic with backoff.
- Credentials live in `secrets.h` (or `secrets.py`), git-ignored, with a committed `secrets.example.h`.
- Telemetry uses one fixed format, such as JSON with `device_id`, `timestamp`, `type`, and `value`.
- Serial logs use levels (`INFO`, `WARN`, `ERROR`) and stay short.
- Document the pin mapping in a table in the README or `docs/`.

**Protocols:**
- MQTT topics form a clear hierarchy: `home/livingroom/temperature`, not `temp1`.
- QoS and retain flags are chosen on purpose and documented.
- Payloads are versioned or self-describing, so the app can change without breaking devices.

**Backend and app:**
- Validate every incoming device message against a schema before use.
- Handle offline devices. Show a "last seen" time instead of a stale value presented as live.
- Never trust device input for anything security-sensitive.

**Hardware safety:** if a project drives relays, motors, or heaters, define a fail-safe default state and a timeout that switches the output off when the controller stops responding.

## B6. Configuration and Secrets

- All configuration comes from environment variables or a config file. Nothing is hardcoded.
- `.env.example` (or `secrets.example.*` for firmware) holds placeholders.
- Never commit API keys, Wi-Fi passwords, MQTT credentials, or Firebase service account files.
- If a secret was ever committed, treat it as compromised. Rotate it, then clean the git history.

## B7. Testing

Every project tests its core logic.

| Layer | What to test | Tools |
|---|---|---|
| Models | Parsing, serialization, validation | `flutter test`, Jest, pytest |
| Services | API and MQTT handling with mocks | `mocktail`, `jest.mock`, `unittest.mock` |
| Firmware | Pure logic (parsers, state machines) | Unity, or host-side tests with PlatformIO |
| Integration | One end-to-end flow, if feasible | Flutter integration tests, Postman collection |

Minimum bar: at least one test per service class and per model. One documented command runs them all.

## B8. Quality Checks Before Publishing

- [ ] Linter: zero errors, no unexplained ignored warnings
- [ ] Formatter has run
- [ ] All tests pass on a clean clone
- [ ] No dead code, commented-out blocks, or unused imports
- [ ] No `TODO` left without a note in the README or an issue
- [ ] No debug prints
- [ ] Dependencies locked (`pubspec.lock`, `package-lock.json`, `requirements.txt`)
- [ ] Runs from a fresh clone using only the README steps
- [ ] Secrets scan passes (`gitleaks` or `git secrets`)

## B9. CI (GitHub Actions)

Each repo gets one workflow that runs lint and tests on every push. Flutter example:

```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

Adapt the steps for other stacks. A green badge in the README is a strong signal.

## B10. Git Conventions

- Branches: `feature/...`, `fix/...`, `chore/...`
- Commits follow Conventional Commits: `feat: add MQTT reconnect logic`, `fix: handle empty sensor payload`, `docs: add pin mapping table`
- Merge through pull requests, even when working alone, so the history reads cleanly.
- Release tags use semantic versions: `v0.1.0`, `v1.0.0`.

---

# PART C: AGENT INSTRUCTIONS

## C1. Process

Work through the project one step at a time. Finish and verify each step before starting the next:

1. **Audit.** Read the whole repo. List what exists, what's missing against this standard, and any secrets or broken parts. Write the audit to `AUDIT.md` and stop for review.
2. **Clean up.** Remove committed build artifacts and dead code. Fix secrets handling per B6. Make no behavior changes here.
3. **Structure and naming.** Align folders and file names with B1 and B2. Move files with their imports updated.
4. **Code quality.** Apply B3, B4, or B5 as relevant. Make the smallest change that meets each rule.
5. **Tests.** Add tests for core logic per B7. Run them.
6. **Quality checks and CI.** Run B8 and add the workflow from B9. Fix every failure.
7. **Documentation.** Write or update the README per Part A and `docs/architecture.md`. Make every claim match the code.
8. **Final report.** Summarize what changed, what passed, and what still needs a human decision.

## C2. Rules

- Don't add features. Don't invent functionality, technology, or results that aren't in the code.
- Don't change behavior unless it fixes a bug or a standard violation. List every behavior change separately in the report.
- If something is unclear, leave a `TODO` in the code and list it in the final report. Don't guess.
- Never print, log, or commit a secret. If you find one, flag it for rotation.
- Keep commits small and follow B10.
- Don't delete the user's original code without a backup branch or tag.

## C3. Prompt to Give the Agent

Paste this, replacing the bracketed parts:

> Read `portfolio-project-standard.md` in full. Then apply it to the project at [path or repo URL].
>
> Follow Part C1 in order. Stop after step 1 (Audit) and show me `AUDIT.md` before making any changes. Once I approve, continue one step at a time, and report after each step.
>
> Follow the rules in C2. Don't add features, and don't change behavior unless it fixes a bug or a standard violation. Mark anything unclear with a TODO and list it for me at the end.
>
> The project is a [Flutter app / ESP32 firmware / backend] for [one-line description]. My role was [solo / team]. The period was [dates]. Status: [live / archived / prototype].
