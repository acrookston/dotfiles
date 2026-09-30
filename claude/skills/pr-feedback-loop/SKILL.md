---
name: pr-feedback-loop
description: Watch a pull request and handle review feedback (human, bot and CI) as it arrives. Verifies each finding, fixes real issues with regression tests, pushes back on wrong ones, replies and resolves threads, and repeats until the PR is clean or blocked on my decision. Use when asked to watch, babysit, loop on or address feedback on a PR.
argument-hint: "[PR number or URL] [interval, default 5m]"
---

# PR feedback loop

Keep the PR moving without me. Each pass: collect new feedback, judge it, act, report.
Stop when nothing is left to do or when a decision is mine.

Reviewers are often wrong, and bots are wrong more often. Your job is to reach the right
outcome for the code, not to make every comment go away.

## Setup (once)

1. Find the PR: use the argument, else `gh pr view --json number,url,headRefName,state`.
   Stop if there is no open PR.
2. Check out the PR branch and run `git pull --ff-only`. If the working tree has unrelated
   uncommitted changes, stop and ask.
3. Read the repo's CLAUDE.md / AGENTS.md and any review bot config, so you judge against
   project conventions.
4. Create a state file at `$(git rev-parse --git-dir)/pr-feedback-<number>.json`. It records
   handled review bodies and PR comments by ID. It lives in `.git`, so it never gets committed.
5. Every reply you post must end with the marker `<!-- pr-feedback-loop -->`. You post with my
   `gh` login, so the marker is the only way to tell your replies from my own comments.

## Each pass

### 1. Collect

```bash
gh api graphql -F owner=OWNER -F repo=REPO -F pr=NUMBER -f query='
query($owner:String!,$repo:String!,$pr:Int!){
  repository(owner:$owner,name:$repo){
    pullRequest(number:$pr){
      state reviewDecision headRefOid
      reviewThreads(first:100){ nodes{
        id isResolved isOutdated path line
        comments(first:50){ nodes{ id author{login __typename} body createdAt url } }
      } }
      reviews(first:100){ nodes{ id author{login __typename} state body submittedAt } }
      comments(first:100){ nodes{ id author{login __typename} body createdAt } }
    }
  }
}'
```

Also run `gh pr checks`. A failing check counts as feedback.

An item needs attention when:

- **Review thread:** unresolved, and the latest comment does not carry your marker.
  Outdated threads still count. Check whether the concern survives in the current code.
- **Review body or PR comment:** its ID is not in the state file and it has no marker.
  Approvals and summaries with nothing actionable go straight into the state file.
- **CI:** a check fails on the current head commit. Ignore checks still running.

### 2. Judge

Verify every finding yourself before acting on it. Read the code on the current head, not the
hunk the reviewer saw. Where you can, prove it: run the test, write a quick failing test, trace
the call path. Confident wording from a bot is not evidence.

Put each item in one bucket:

| Bucket | When | Action |
|---|---|---|
| **Fix** | Real bug or clear defect introduced by this PR | Fix with regression test |
| **Improve** | Valid, small, low risk, in scope (unclear name, missed edge case, weak test) | Just do it |
| **Push back** | Wrong, or matches the skip list below | Reply with evidence |
| **Out of scope** | Real, but predates this PR or belongs elsewhere | Reply, suggest a follow-up issue |
| **Ask me** | Design, product or architecture call; scope change; reviewers disagree; a human insists after one push back; still unsure after verifying | Don't reply. Raise it in the report |

Do not act on these. Push back briefly instead:

- Hypothetical future concerns ("if X ever changes, Y breaks"). Review the code as it is.
- Missing validation on trusted internal values: system-generated IDs, known config.
- "Worth noting" observations. If you would not block the PR over it, it doesn't need a change.
- Style the project's formatter or linter owns. Run the tool instead of hand-editing.
- Test timing or sleep fragility, unless CI history shows the test actually flaking.
- Repeats of a finding already handled in another thread. Link to that thread.

For human reviewers, answer the intent, not just the literal comment. If a question hides a
concern ("why is this here?"), address the concern.

If you are unsure after checking, say so in the reply. Don't guess with confidence.

### 3. Fix

- **Real bug:** write the regression test first and confirm it fails without the fix. Then
  fix and confirm it passes.
- **Look for siblings.** The same mistake often appears more than once. Search the code this PR
  touches and related code paths for the same pattern. Fix any this PR introduced. List
  older ones in the report and leave them unless trivial and in the same module.
- Run the affected tests, linter and type checker before committing.
- Commit per finding, or per tight group of related findings. Never amend or force-push:
  replies cite SHAs and must stay valid.
- Push once per pass, after all checks pass locally.

### 4. Reply and resolve

Only reply after the push succeeds, so the SHA exists on the remote.

```bash
# Reply to a thread
gh api graphql -F thread=THREAD_ID -F body="$BODY" -f query='
mutation($thread:ID!,$body:String!){
  addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$thread, body:$body}){ comment{ id } }
}'

# Resolve a thread
gh api graphql -F thread=THREAD_ID -f query='
mutation($thread:ID!){ resolveReviewThread(input:{threadId:$thread}){ thread{ isResolved } } }'
```

Keep replies short and factual:

- **Fixed:** "Fixed in `abc1234`: <what changed, one line>. Regression test: `test_name`."
  Mention sibling fixes if any. Then resolve.
- **Pushed back:** "Not changing this: <evidence, e.g. code path, test, docs>." Resolve bot
  threads. Leave human threads open for the reviewer to close.
- **Out of scope:** say why and suggest a follow-up. Same resolve rule as push back.
- **Ask me:** no reply yet.

For review bodies and PR comments, reply with `gh pr comment` and quote the point you answer.
Then add the ID to the state file.

A bot that repeats a finding after your push back gets one line linking the earlier reply,
then resolve. Don't argue twice.

### 5. Report

Print a short summary only when something happened: fixed (with SHAs), pushed back, out of
scope, waiting on me, siblings found. Put "waiting on me" items first, with the question
phrased so I can answer in one line.

## Looping

After a pass, wait, then run the next one. Default interval 5 minutes.

- Use the session's scheduling tool if one exists (e.g. `ScheduleWakeup` or `/loop`).
- Otherwise run `sleep 270` in Bash, under the tool timeout, and repeat.
- After pushing, wait for CI to finish before judging checks.
- Back off: after three empty passes in a row, double the interval, up to 30 minutes.
  Reset to the default when new feedback arrives.

Stop when:

- The PR is merged or closed.
- The PR is approved, checks are green and no item needs attention. Report done.
- Only "ask me" items remain. Report them and stop.
- The same CI failure survives two fix attempts. Report what you tried.
- Two hours pass with no new feedback.

## Learning

If the same kind of finding appears twice, in this PR or across PRs, propose a one-line rule
for the right CLAUDE.md or AGENTS.md in the report. Don't edit those files yourself.

If a bot keeps raising skip-list items, suggest a change to its config instead.
