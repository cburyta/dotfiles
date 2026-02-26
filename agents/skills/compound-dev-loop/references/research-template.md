# Research Output Template

## Format

```markdown
# Research: <Task Name>

## Summary
One paragraph describing what was found and the recommended approach.

## Relevant Files

| File | Lines | Purpose |
|------|-------|---------|
| `src/auth/login.ts` | 45-89 | Current login flow |
| `src/utils/token.ts` | 12-34 | Token validation |

## Code Flow

1. User calls `login()` in `src/auth/login.ts:45`
2. Validates credentials via `validateUser()` at line 52
3. Generates token using `createToken()` from `src/utils/token.ts:12`
4. Returns response at line 89

## Existing Patterns

- Error handling: Uses `AppError` class from `src/errors.ts`
- Validation: Zod schemas in `src/schemas/` directory
- Testing: Integration tests in `__tests__/` alongside source

## Constraints

- Must maintain backward compatibility with v1 API
- Rate limiting already applied at middleware level
- Database transactions required for multi-table updates

## Open Questions

- [ ] Should we deprecate the old endpoint?
- [ ] What's the expected load increase?
```

## Guidelines

- Include actual line numbers, not approximations
- Code snippets should be minimal but sufficient
- Patterns section helps agent match existing style
- Constraints prevent agent from breaking things
- Open questions surface decisions for human
