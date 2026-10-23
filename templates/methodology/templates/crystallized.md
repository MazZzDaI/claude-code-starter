---
maturity: crystallized
id: <kebab-case-stable-id>
domain: <pipeline-design | content | extraction | classification | ...>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
applies_when: []        # routing signals: when router should pick this methodology
does_not_apply: []      # exclusion signals
inputs_required: []     # what data the executor needs
outputs_produced: []    # what the executor produces
composes_with: []       # other methodology ids it chains with
related: []
---

# Methodology: [name]

## Concept
[1 paragraph]

## Routing signals
[how the router determines applicability, in formalised form]

## Decomposition (judgment vs bookkeeping)
- **Judgement (LLM):** what the model decides
- **Bookkeeping (code):** what the code counts/checks
- The boundary between them (an important part: see [[rules/llm-as-component]])

## Prompt skeleton (for executor)
```text
[Prompt template with {{input_x}} placeholders]
```

## Anti-patterns
- ...

## Composition notes
- How it connects to other methodologies (id references)
- What data it passes on

## Examples and traces
- links to specific applications

## Implementation in code
- `path/to/file.py` — what exactly it does
- Which parts stayed with the LLM, which were made deterministic

## Transition history
- What caused the crystallisation (stability? cost? speed?)
- What was discarded along the way

---
*Crystallized means the methodology lives both as a specification (this file) and as code. When the code changes, update this file, otherwise the specification will drift out of sync with the implementation.*
