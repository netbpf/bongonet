# Bongonet Discussions: community design for long-term contributors

## Project analysis (what the community needs)

| Signal in the repo | Community implication |
| --- | --- |
| 24 workspace crates, public `bongonet` facade plus focused crates | Contributors need a place to discuss crate boundaries and API changes before writing code |
| `CONTRIBUTING.md`: issue-first for non-trivial PRs, internal work takes priority, maintainers rebase accepted PRs | A contributor-only space helps set expectations and coordinate reviews without cluttering `Issues` |
| 9 open RUSTSEC/dependency issues (#3, #4, #7, #12, #13, #16, #18, #19, #23) | A maintenance lane is needed to claim and drive dependency/security work |
| Docs gaps: API reference `TBD`, `peer.md` `TBD`, "Advanced topics (WIP)" (BoringSSL, user config, runtime/threading, background service, blocking code, tracing), HTTP caching WIP | Documentation and internals work are concrete, scoped entry points for new and long-time contributors |
| 26 runnable examples (proxy filters, modules, gRPC-web, virtual L4, health-aware selection) | A "show and tell" venue can turn examples into community extensions |
| MSRV 1.85 (foundations 1.88), 6-month MSRV policy, 4 TLS backends | Toolchain/TLS-backend policy discussions need a durable home |
| `make check` (fmt, clippy `-D warnings`, tests, release build), audit/deny/semgrep CI | Contributors need a place to discuss CI failures and local setup before opening PRs |

## Category design

Existing defaults: `Announcements`, `General`, `Ideas`, `Polls`, `Q&A` (slug `q-a`), `Show and tell`.

| Category | Slug | Purpose | Template |
| --- | --- | --- | --- |
| Announcements | `announcements` | Releases, RFC outcomes, community news | — |
| Q&A | `q-a` | Usage/troubleshooting questions | `q-a.yml` |
| Ideas | `ideas` | Enhancement proposals, API sketches, design discussion before code | `ideas.yml` |
| Show and tell | `show-and-tell` | Extensions, integrations, and examples built on Bongonet | — |
| General | `general` | Open community discussion | — |
| Polls | `polls` | maintainer-run polls | — |
| **Contributor Corner** *(new)* | `contributor-corner` | Review coordination, mentoring, PR ownership, how to grow into a maintainer | `contributor-corner.yml` |
| **Maintenance & Roadmap** *(new)* | `maintenance-roadmap` | RUSTSEC/dependency remediation, MSRV bumps, CI changes, docs WIP, release planning | `maintenance-roadmap.yml` |

Notes:
- Rename `Q&A` to `Questions` only if the slug is changed too; templates are keyed by **slug**, so
  `questions.yml` is inert while the category slug is `q-a`. `q-a.yml` is provided instead.
- Keep `Ideas` for design work so enhancement proposals stay discoverable and separate from bugs.

## Seed discussions (post after categories exist)

1. **Announcements** — `Welcome to Bongonet Discussions`
   Body: `docs/discussions_landing.md`.

2. **Maintenance & Roadmap** — `Call for owners: the 9 open RUSTSEC dependency issues`
   Link issues #3, #4, #7, #12, #13, #16, #18, #19, #23; ask contributors to claim one, propose the
   upgrade/removal path, and note which TLS backend or MSRV constraints apply.

3. **Contributor Corner** — `How to become a regular contributor (and what to expect)`
   Summarize `CONTRIBUTING.md`: start with an issue, small fixes may go straight to PR, non-trivial
   PRs need an issue, internal contributions take priority, accepted PRs are rebased by maintainers.
   Ask long-time contributors to share review/ownership norms.

4. **Ideas** — `Fill the Advanced topics (WIP) documentation`
   Enumerate the WIP topics in `docs/user_guide/index.md` plus the missing API reference and
   `peer.md` `TBD`; ask for volunteers and a proposed docs toolchain (docs.rs vs in-repo guide).

5. **General** — `Release cadence and MSRV policy after 0.4.0`
   Discuss the 1.85 MSRV, 1.88 for `bongonet-foundations`, the 6-month rolling policy, and the four
   optional TLS backends.

6. **Show and tell** — `What have you built with the proxy filter APIs?`
   Point at `crates/bongonet-proxy/examples/` (gateway, body routing, virtual L4, gRPC-web, rate
   limiter) and invite people to share extensions.

## Moderation and operating model

- Pin the welcome post and the "How to become a regular contributor" post.
- Long-time contributors can be given category moderation rights for `Q&A` and `Show and tell`;
  keep `Announcements` maintainer-only.
- Cross-link issue templates to `Q&A` and `Ideas` (see `.github/ISSUE_TEMPLATE/config.yml`).
- Close the loop: when a discussion produces a concrete change, open an issue/PR and link back.

## Publishing steps (manual setup + gh)

1. Repo Settings → Discussions → create `Contributor Corner` and `Maintenance & Roadmap` and add
   the templates below; optionally rename `Q&A`.
2. With a token that has Discussions write access:

```sh
gh discussion create -R netbpf/bongonet --category "Announcements" \
  --title "Welcome to Bongonet Discussions" --body-file docs/discussions_landing.md
gh discussion create -R netbpf/bongonet --category "Maintenance & Roadmap" \
  --title "Call for owners: the 9 open RUSTSEC dependency issues" --body-file <seed-file>
```

The current `GITHUB_TOKEN` cannot do step 2: `createDiscussion`/`updateDiscussion` return
`Resource not accessible by integration`, and there is no API to create discussion categories.
