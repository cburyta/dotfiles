Look for a fix we've resolved in our project or an issue we have run into, in relation to an open source project.

Context required before continuing
- working directory for the project
- bug or feature that needs to be resolved
- sample of how we resovled the bug, or the work around

## Workflow

1. Review contributing instruction for that project
2. Evaluate the commit history to understand how to craft commit messages
3. Create a new branch (use semantic prefix)
4. Add a test to recreate the error + make a commit
5. Apply the patch + ensure the test we created pass after the fix + create a commit
6. Request a code review. (from a subagent) See the subagent prompt for reference.

---

**Subagent prompt**

DO NOT code review your own code if the subagent tool is not avaialable, pause here instead.

```
/consolidate-tests
Review the specific tests we updated/added: {list the tests and/or context of our change}
```

---

If you run into any issues, try to iterate a solution, and always ask an agent for a code review at the end of any iterations.

Finally, create a new markdown file, with a concise pull review message.
