# Consolidate unit tests

## Goal

Reduced amount of code to maintain, reduce error prone test patterns.

## Flow

Identify areas to reduce test codebase

1. Look for duplicated tests
2. Look for tests that could be parameterized (same test just testing different states)
3. Look for tests that are covered in higher level unit tests (example, CLIRunner test that would fail if a validation function fails, means that the smaller validation function does not need a dedicated unit test.)
4. Very low value tests
5. Verify tests logically look to test what is intended, if unclear ask for clarity

For each test found plan to remove or merge it's logic into another test.

## Review tests and evaluate where tests can be consolidated
- ensure coverage remains similar (slightly less coverage is OK with user input)
- consider low value tests to prune
- consider low value test lines to prune or consolidate
    - DO NOT test all props without purpose
    - DO test only minimal props needed to assert correctly
- look for common setup that should be moved into shared fixturs
- try to keep fixtures local to the module (e.g. test/module/file1.py and test/module/file2.py sharing a fixture would be in test/module/conftest.py, not a global tests/conftest.py unless other modules also use that fixture data)

## Specific points to review and fix

- DO NOT mock boto3 based mocking
- DO use moto to mock things like S3 buckets

Create a summary list of the reasons for the suggestions and ask for permission to proceed. Provide a matrics measuring value added from the test compared to complexity and maintance of keeping it.
