# Plan Output Template

## Format

```markdown
# Plan: <Task Name>

## Overview
Brief description of what will be implemented and why.

## Prerequisites
- [ ] Research document reviewed: `memory/research/<task>.md`
- [ ] Dependencies identified: none / list them

## Steps

### Step 1: <Description>

**File:** `src/auth/login.ts`
**Lines:** 45-60

**Current code:**
```typescript
export async function login(email: string, password: string) {
  const user = await findUser(email);
  // ... existing implementation
}
```

**New code:**
```typescript
export async function login(email: string, password: string, mfaCode?: string) {
  const user = await findUser(email);
  if (user.mfaEnabled && !mfaCode) {
    throw new MfaRequiredError();
  }
  // ... rest of implementation
}
```

**Verify:** Run `npm test -- --grep "login"` - expect all tests pass

### Step 2: <Description>

...continue pattern...

## Testing Plan

1. Unit tests: Add tests for new MFA flow
2. Integration: Test full login with MFA enabled/disabled
3. Manual: Verify UI prompts for MFA code

## Rollback

If issues arise:
1. Revert commit with `git revert HEAD`
2. Feature flag: Set `MFA_ENABLED=false` in env
```

## Guidelines

- Each step is atomic and independently verifiable
- Include before/after code snippets
- Verification command after each step
- Testing plan covers unit, integration, manual
- Rollback section for production safety
