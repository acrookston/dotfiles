# Global working rules

Project `CLAUDE.md` / `AGENTS.md` files take precedence where they conflict with this file.

## Definition of ready

Substantial work (multi-file changes, new behaviour, schema or API changes) starts only when these
exist, written down in the plan, the issue, or your first update:

1. **Intent**: the problem and the intended outcome in a sentence or two, plus what is out of scope.
2. **Acceptance criteria**: observable behaviour, including error and empty states. For UI, the
   interactions that make it finished (resizing, keyboard, editing, limits).
3. **Verification plan**: the check that proves each criterion (an existing test, a new failing
   test, a browser flow). Say up front if a criterion can't be checked automatically.

If the issue, code, or docs don't answer these, write a short plan and ask me to confirm it before
coding. If they do, state them and proceed. A fix you can describe in one sentence skips this.

## Definition of done

- Run the checks that cover the change (types, lint, tests; for UI, drive it in the browser) and show
  the evidence: the command and its result, or a screenshot. List anything left unverified.
- Bug fixes start with a test that fails without the fix.
- Before opening a PR, review the diff in a fresh subagent (`/code-review`). Fix findings that affect
  correctness or the acceptance criteria; don't add defensive code just to satisfy a reviewer.

## Autonomy

- Don't stop to ask what you can check yourself. Come back when the checks pass or when you're
  blocked on a decision that's mine.
- When I correct something that is likely to recur, propose a one-line rule for the right
  CLAUDE.md or AGENTS.md.

## Git & branch hygiene

- Before starting a task, `git fetch origin` and check how far the branch/worktree is behind
  `origin/main`. If it is behind, rebase or branch fresh from `origin/main` before writing code.
- Before opening a PR, `gh pr list --state open` and check whether an open PR already covers the
  work. Before pushing to an existing PR, confirm it is still open (`gh pr view <n> --json state`);
  never push to a merged PR.
- When a prerequisite branch exists, branch from it instead of waiting for it to merge.

## PR review feedback

- Verify every review finding (human or bot) yourself before acting on it. Push back with evidence
  on findings that are wrong.
- For a real bug, add a regression test that fails without the fix.
- After fixing a thread, reply with what changed and the commit SHA, then resolve it
  (`gh api graphql` `resolveReviewThread`). A fixed but unresolved thread looks unaddressed.

## Local dev environment

- Never kill dev servers, database stacks, or processes on shared ports without asking. They may
  belong to me or to another worktree.
- Worktrees share ports. Check `lsof -i :<port>` before starting servers or e2e runs; use a free
  port or ask.
- Diagnostic commands that can hang (curl, nc, port scans) need a timeout.

## Accuracy & communication

- Before claiming a tool or config is absent, check the repo: `package.json` scripts, lockfiles,
  README.
- State only what you verified. Don't overstate benefits, effort, or confidence; hedge until
  checked.
- When diagnosing, list the competing hypotheses and the evidence for each before committing to one.
- Keep status summaries short (5–8 bullets) unless asked for more.
- When asked to update docs, edit them in place. Don't draft change notices unless asked.

## Known pitfalls

- Supabase/PostgREST reads are capped at 1,000 rows. Paginate bulk reads.
- Global keyboard shortcuts must ignore events targeting inputs, textareas, and contenteditable.
- Playwright label locators: use `{ exact: true }` to avoid substring matches.
