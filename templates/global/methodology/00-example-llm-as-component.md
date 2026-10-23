---
maturity: mature
id: llm-as-component
domain: pipeline-design
created: 2026-06-11
updated: 2026-06-11
applies_when:
  - pipeline-design
  - multi-step-llm-chain
  - "many decisions of the same kind on noisy data"
  - extraction
  - classification
  - normalization
  - cleanup
  - ranking
  - labeling
does_not_apply:
  - a one-shot answer to the user in an interactive chat
  - a creative task with no verifiable contract
  - a task where the "bookkeeping" is naturally degenerate (a single item as input)
inputs_required:
  - a raw, noisy set of items of the same kind
  - domain criteria for "what is in / what is out / what granularity" (per slice)
outputs_produced:
  - a clean, deduplicated, correctly categorised set
  - an explicit report of losses/drops (what was thrown out and why)
composes_with:
  - router-pattern        # the router selects the slice/category to apply this pattern to
  - chunking-strategy     # how exactly to split the input
  - contract-validation   # code that checks completeness/invariants
related: []
---

# Methodology: The LLM as an unreliable pipeline component

## Concept

The quality of a model's output is not a property of the model but a function of how narrowly the task is bounded and how rigidly the output contract is formalised. The engineering lies not in "asking it to do a good job" but in making a class of errors structurally impossible. A strong reasoning model designs and verifies the pipeline **offline**, and the runtime is assembled from cheap models in small, focused windows plus deterministic code that does all the bookkeeping.

## Routing signals

Apply if **all** of these conditions hold:

1. The task is a series of decisions of the same kind (not a single unique one).
2. The input is noisy (duplicates, typos, imprecise categories, outliers).
3. There is a verifiable contract for the result (completeness, dedup, invariants).
4. The direct approach of "everything in one prompt to a large model" already degrades (losses, duplicates, confused categories) — or predictably will.

Exclusion signals (`does_not_apply`):

- An interactive one-shot answer to the user.
- A creative task without a contract.
- Degenerate bookkeeping (a single item as input — nothing to keep track of).

## Decomposition (judgment vs bookkeeping)

- **Judgement (LLM):**
  - is it relevant?
  - is it meaningful?
  - is it important?
  - what should it be called / how should it be translated / categorised?

- **Bookkeeping (code):**
  - completeness (did every item receive a decision)
  - dedup by canonical label
  - aggregation (summing frequencies, ranks)
  - sorting, caps, contract validation
  - projection into the final format

- **Boundary:** the model never keeps the accounts. If you are tempted to ask the model to "collapse duplicates in its head" or "return only the unique ones", that is a sign the bookkeeping has leaked into the LLM. Move it back into code. More detail: [[rules/llm-as-component]].

## Prompt skeleton (for executor)

```text
You receive ONE item: "{{item}}".

Slice context: {{slice_description}}

Inclusion criteria:
{{inclusion_criteria}}

Exclusion criteria:
{{exclusion_criteria}}

Example of the desired behaviour:
input: "{{example_input}}"
output: {{example_output}}

Return strictly one of:
- {"decision": "keep", "canonical_label": "<string>"}
- {"decision": "drop", "reason": "<short reason>"}

Do NOT return multiple items. Do NOT collapse duplicates — the code will do that.
Do NOT add fields beyond the contract.
```

Key properties of the scaffold:
- the decision is made **one item at a time** (focus window = 1);
- the response contract makes "losing an item" structurally impossible;
- forbidding extra fields removes an entire class of failures;
- the built-in example (example_input/output) — the model follows a demonstration better than a declaration.

## Anti-patterns

- **"One big prompt for the whole list"** — the model loses items, invents non-existent ones, multiplies duplicate groups. Root cause: overload from simultaneous judgement and bookkeeping.
- **"Return every item verbatim"** — the model does not reproduce ≥100 lines accurately. Solution: work by positions/indices, or one item at a time.
- **"Return the decision by number"** in a large window — the model "collapses duplicates in its head" and breaks the number↔item correspondence. Solution: each item is a separate call.
- **"Forbid the error in the instruction text"** — gets ignored. Solution: one concrete example of the desired behaviour fixes the defect in one go.
- **"A statistical threshold will solve everything"** — thresholds (frequency, length) are crude and cut out what matters. Solution: arbitration of the tail is handed to judgement, not to a threshold.
- **"A strong model at runtime"** — expensive, slow, not reproducible. Solution: the strong model designs offline and steps out; the runtime is a cheap model + code.

## Composition notes

This methodology usually chains like this:

```
[router-pattern]
  selects the slice/category (what we are working through now)
        ↓
[chunking-strategy]
  prepares small, focused windows (usually one item each)
        ↓
[llm-as-component] ← THIS methodology
  the prompt skeleton is applied to each item independently
        ↓
[contract-validation]
  code checks completeness (did every item receive a decision),
  dedups by canonical_label, aggregates frequencies, validates the contract
        ↓
[output projection]
  final format for downstream
```

What this methodology **passes on**: a `{decision, canonical_label}` set for each input item, with no aggregation. Aggregation is the next step's concern.

What it **expects from the router**: an already selected slice and the loaded domain criteria (inclusion/exclusion) — the methodology does not guess them itself.

## Examples and traces

**The case the principle was derived from (format: problem → … → confirmation):**

- **Problem.** From a raw, noisy set of tags we needed a clean, deduplicated, correctly categorised set. The direct approach of "give a clever model the whole list and ask it to tidy up" produced rubbish: lost items, duplicates, wrong categories, lost frequencies.

- **Attempts.**
  1. One big prompt for all categories / the whole list → losses and fabrications.
  2. A "return every tag verbatim" contract → 150 lines are not reproduced accurately.
  3. A "return the decision by number" contract → duplicates collapsed in its head, number↔item desync.

- **Root-cause search.** The root was overload: the model was simultaneously doing *judgement* (what to keep, where to put it) and *bookkeeping* (tracking all items, dedup, numbering, frequencies). The larger the input, the worse the degradation.

- **Hypothesis.** Leave the model **only** the judgement on one item at a time in a small window; move tracking/dedup/aggregation into deterministic code. Reliability will rise by an order of magnitude at the same token cost.

- **Experiment.** Small chunks; independent labelling of each item (canonical or drop); dedup and summing in code by canonical label; a specific class of error forbidden via an example in the prompt; separate criteria for each slice. The reasoning model acts as the evaluator in the loop: run → read the result → amend the prompt, 2–3 iterations per slice.

- **Confirmation.** All slices: dedup, correct scope, what matters preserved, desync ≈ 0. Systemic defects (frequency loss on duplicates, category confusion) were eliminated **not by coaxing the model** but by structure.

## Principles (domain-independent)

1. **Split the task into "judgement" and "bookkeeping".** The model is for judgement; code is for tracking. Never ask the model to keep the accounts: it is its weakest side.

2. **Task size = reliability.** Split the input into small, focused windows. A large input degrades quality non-linearly. A series of small calls at the same token cost yields quality and speed an order of magnitude higher than one big call.

3. **Design the contract so that a class of errors is impossible, not merely unlikely.** A decision by position/index guarantees completeness; independent labelling removes "collapsing in its head"; forbidding an extra field removes an entire type of failure.

4. **An example beats a rule.** One concrete, demonstrated example of the desired behaviour fixes the defect in one go.

5. **Statistics are a signal, not a law; at the tail, judgement decides.** The rare but significant must survive; the frequent but empty must be cut off.

6. **The artefact is the criteria, not the algorithm.** The main value is an explicit, verifiable formalisation of domain judgement (what is in / what is out / what granularity), separate for each slice.

7. **Source vs derivative.** Separate the immutable source from the rebuildable derivative. If the result is a derivative, iterate boldly: the fear of "breaking the data" goes away.

## Architecture (role pattern)

**The strong reasoning model is the offline designer and evaluator, NOT the runtime executor.**

```
[Strong model / reasoning]  — OFFLINE, in a feedback loop:
   designs the decomposition (judgement↔code),
   writes the criteria and the contract,
   runs the cheap executor, reads the output, amends — until stable,
   then STEPS OUT of the pipeline.
        │  (leaves behind: criteria + contract + code harness)
        ▼
[Cheap model]  — RUNTIME: repeatably makes a narrow judgement in a small window.
        │
        ▼
[Deterministic code]  — RUNTIME: tracking, dedup, aggregation, validation, projection.
```

Rules of the pattern:
- The strong model must not be *inside* the runtime. Its job is to build a system out of cheap, reliable steps and to be able to verify it, and then to step aside.
- Every runtime step must be verifiable by code (completeness, invariants), not taken "on trust".
- The strong model's value lies not in doing the work but in designing and verifying a system that does the work without it.

**Applicability test:** if the task is "many decisions of the same kind on noisy data", it almost certainly decomposes along this pattern. Ask: where is the judgement here (→ cheap model, small window), where is the bookkeeping (→ code), what contract makes the error impossible, and which criteria for each slice need to be formulated offline.
