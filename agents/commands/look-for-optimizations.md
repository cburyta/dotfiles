I'd like to evaluate each function and query that runs so we can try to reduce the time it takes to run.

Systematically follow the process in code and create a checklist of functional areas to review.

Then for each component evaluate
- data transfer overhead (moving or loading data)
- compute heavy processes
- nonperformant loops
- disk read/write operations

Pair this with a logical description of the intent of the components based on the docs, and code.

For each component, main operation evaluate if there are any optimizations to be had if there are clear wins.

Formalize this in a document with an executive summary, and for each component a matrix of value vs performance cost vs effort to improve that section.

Possiblie optimizations for example (not limited to) may be
- running components in parallel (e.g. argo or async functions) - verify if there are logical blockers
- more optimal methods (e.g. .apply on a pandas data frame is usually slower than .map on large data sets)
- uploading/downloading to S3 and inserting with native datababase loading flows vs batchs of INSERT/SELECT statements
