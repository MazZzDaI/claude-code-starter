---
title: Architecture
type: architecture
status: draft
updated: YYYY-MM-DD
---

# Architecture

<!--
This file is a living map of the system. Not a history and not a plan, but the answer to the question
"where is everything and how is it connected". Update it when the structure changes, not
when you edit a particular file.

Contract layer (what should be), not the state layer (what is right now).
State lives in SNAPSHOT.md, the plan in BACKLOG.md, hard prohibitions in
INVARIANTS.md.
-->

## System map

<!--
High-level: what exists in the project at all. Modules, services, storage, external
integrations. One line per unit. If you draw an ASCII diagram, excellent,
but a list is also acceptable.
-->

- <!-- Example: `api/` — HTTP entrypoint, routing, request validation -->
- <!-- Example: `core/` — business logic, isolated from transport and the DB -->
- <!-- Example: `storage/` — adapters for SQLite (local) and Postgres (cloud) -->
- <!-- Example: external integration: Stripe (payments), SendGrid (email) -->

## Layers and boundaries

<!--
Who may call whom. Dependencies point from top to bottom. If a rule
is broken, it is either architectural debt (record it in BACKLOG) or an error
(record it as an INVARIANT violation).
-->

- <!-- Example: `api → core → storage`. Reverse calls are forbidden. -->
- <!-- Example: `core` knows nothing about HTTP and imports nothing from `api/`. -->
- <!-- Example: tests may import anything; production code only downwards. -->

## Key contracts

<!--
Names + a one-line purpose. Details (field schemas, error codes, edge
cases) live in the code or in INVARIANTS.md. This is a map, not a reference manual.
-->

- <!-- Example: `POST /api/v1/orders` — creates an order, idempotent on `client_token` -->
- <!-- Example: event `order.paid` — published after a successful payment -->
- <!-- Example: table column `users.email` — unique, lower case -->

## Entry points and outputs

<!--
Where the code is launched from in the first place and where it sends its results. CLI commands,
public APIs, cron/scheduled jobs, webhooks.
-->

- <!-- Example: `npm run dev` — local server on :3000 -->
- <!-- Example: cron `cleanup-expired` — once a day at 03:00 UTC -->
- <!-- Example: webhook `/stripe/events` — incoming payment events -->

## Dependencies

<!--
External services and libraries that shape the architecture (not every
npm dependency, but those that define the shape of the system). If the dependency
disappears, what breaks.
-->

- <!-- Example: Postgres — the main storage; nothing works without it -->
- <!-- Example: Redis — cache and rate limiting; if it goes down, degradation rather than failure -->
- <!-- Example: the `zod` library — validation of all external inputs -->

## Open questions

<!--
Architectural decisions that have not yet been made. These are not bugs or tasks —
they are forks in the road where you need to stop and think before
moving on. Once a question is settled, it is moved into the main text
above or deleted.
-->

- <!-- Example: a single or separate storage for analytics and production? -->
- <!-- Example: where does authorisation live — in the API layer or in core? -->
