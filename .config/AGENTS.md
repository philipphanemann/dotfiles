These rules apply to every task in this project unless explicitly overridden.
Bias: caution over speed on non-trivial work. Use judgment on trivial tasks.

## Rule 0 - Look for llms.txt
Read the llms.txt file if it exists, before scanning the complete repository. It contains valuable information about the project structure. 

## Rule 1 — Think Before Coding
State assumptions explicitly. If uncertain, ask rather than guess.
Present multiple interpretations when ambiguity exists.
Push back when a simpler approach exists.
Stop when confused. Name what's unclear.

## Rule 2 — Simplicity First
Minimum code that solves the problem. Nothing speculative.
No features beyond what was asked. No abstractions for single-use code.
Test: would a senior engineer say this is overcomplicated? If yes, simplify.

## Rule 3 — Surgical Changes
Touch only what you must. Clean up only your own mess.
Don't "improve" adjacent code, comments, or formatting.
Don't refactor what isn't broken. Match existing style.

## Rule 4 — Goal-Driven Execution
Define success criteria. Loop until verified.
Don't follow steps. Define success and iterate.
Strong success criteria let you loop independently.

## Rule 5 — Use the model only for judgment calls
Use me for: classification, drafting, summarization, extraction.
Do NOT use me for: routing, retries, deterministic transforms.
If code can answer, code answers.

## Rule 6 — Use token budgets as planning thresholds
Use approximately 8,000 tokens for a focused task and 15,000–20,000 tokens for a
substantial task spanning multiple project layers. Plan for approximately 40,000–60,000
tokens per session, with a checkpoint before beginning another major workstream.
Token usage estimates are planning guides, not reliable live counters. At a task
threshold, checkpoint progress and reassess scope; do not stop with required work
unfinished or claim completion when anything remains. If work must continue separately,
record what is complete, what is verified, and what remains.

## Rule 7 — Surface conflicts, don't average them
If two patterns contradict, pick one (more recent / more tested).
Explain why. Flag the other for cleanup.
Don't blend conflicting patterns.

## Rule 8 — Read before you write
Before adding code, read exports, immediate callers, shared utilities.
"Looks orthogonal" is dangerous. If unsure why code is structured a way, ask.

## Rule 9 — Tests verify intent, not just behavior
Tests must encode WHY behavior matters, not just WHAT it does.
A test that can't fail when business logic changes is wrong.

## Rule 10 — Checkpoint after every significant step
Summarize what was done, what's verified, what's left.
Don't continue from a state you can't describe back.
If you lose track, stop and restate.

## Rule 11 — Match the codebase's conventions, even if you disagree
Conformance > taste inside the codebase.
If you genuinely think a convention is harmful, surface it. Don't fork silently.

## Rule 12 — Fail loud
"Completed" is wrong if anything was skipped silently.
"Tests pass" is wrong if any were skipped.
Default to surfacing uncertainty, not hiding it.

## Rule 13 — Trust input contracts
Assume inputs satisfy their declared types and schemas. Use direct access to required fields; do not repeat guaranteed checks, conversions, or fallback defaults.
Validate at external and independently constructible public boundaries, and check additional invariants introduced by transformations.
Test contract violations at validation boundaries, not in downstream functions.

## Python conventions

### Design
Keep transformation logic in pure functions — no side effects.

### Typing
Add type annotations for all parameters and return values of every Python function or method you create or modify. Prefer existing dedicated project types, or create a domain-specific type when appropriate, instead of using generic types.
Use full schema or domain type names in function and method parameter annotations instead of local aliases. Local aliases may still be used in function bodies for concise column references.
Test functions should omit the `-> None` return annotation.

### Validation
Express validation in Pydantic models or Pandera schemas rather than separate helper functions when possible. Prefer built-in field constraints for simple field-level rules, then custom model or schema validators for rules involving multiple fields or columns. Use standalone validation functions when logic is shared across validation boundaries, is too complex to express clearly in the schema, or depends on external information. Built-in constraints do not need unit tests for framework behavior; directly test custom validators and standalone validation functions.
When a constructed DataFrame already has exactly the target schema's columns, validate it directly instead of selecting those same columns immediately before validation. Keep a projection only when it intentionally filters or reorders columns, or removes extra columns.

### Function naming
Give newly created Python functions and methods concise, intention-revealing names. Use a specific verb that describes the operation or result. Name boolean predicates with established forms such as `is_...`, `has_...`, or `can_...`. Avoid generic verbs such as `process`, `handle`, `run`, or `do` unless additional words make the function's specific responsibility unambiguous. Preserve established project terminology and naming conventions. Rename existing functions only when their names are misleading and the rename is within the task's scope; account for all callers and public API compatibility.

### Testing
Every new function containing validation, transformation, or business logic must have direct unit tests in the same change, including private helpers. Tests must call that function directly; tests through its callers do not count. Before declaring completion, verify those tests exist and pass.
Use polars or pandas `assert_frame_equal` / `assert_series_equal` instead of individual element assertions or set/length checks. Almost always construct an explicit expected Series or DataFrame and compare with `assert_series_equal` / `assert_frame_equal`.
Prepare simple number examples instead of chaining preprocessing functions.
Use pytest-parametrized test functions when only the arguments vary; do not duplicate test logic. Give every parameter case a concise, behavior-oriented description in test output, using `pytest.param(..., id="...")`, `ids=...`, or another clear pytest-supported method. Apply this when amending tests too.
Name unit tests `test_<function_name>__<behavior_description>` and call the function under test directly. Test higher-level wiring separately when needed.
Test nothing which is implied, e.g. via type hints.
Do not run tests marked as "slow" which are obviously not affected by the provided task.
Automatically run only tests whose covered behavior may be affected by the current change. Identify these by inspecting the changed code, its callers, shared dependencies, and existing tests. Include integration tests when the change may affect interactions between components. Broaden the test selection only to cover additional affected behavior, investigate a relevant failure, or fulfill an explicit user request. Do not run the full test suite by default.

## Other conventions
When refactoring keep TODO comments and list them afterwards.

