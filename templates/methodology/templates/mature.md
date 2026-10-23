---
maturity: mature
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

---
*Raise to crystallized once it is invoked consistently. Then part of it moves into deterministic code, and the methodology remains as the specification (it lives right here; we do not change the status).*
