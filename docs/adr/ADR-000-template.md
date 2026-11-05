# ADR-NNN: AI-assisted Campus Feed implementation and offline caching


**Date: 2026-11-05**  **Author:Dipta Das Gupta**  **Milestone:** Lab 4 
**Tool and model used:ChatGPT (GPT-6)**

## Context
I needed to complete the TODO sections of a Flutter Campus Feed app that fetches posts from a web API and saves them for offline use. The app also needed loading, error, and offline states, plus SQLite storage that survives app restarts. I wanted to preserve the instructor's comments, class structure, and supplied tests while completing the implementation.


## Prompt
```
Help me complete Lab 4 step by step. Keep the instructor's comments,
instructions, file structure, and tests unchanged. Only implement the
required TODOs for the Post model, repository, ViewModel, screen, and
SQLite cache, then help me add two meaningful tests.
```

## Result
ChatGPT helped implement the JSON model, network-first repository with cache fallback, ViewModel state handling, screen states, SQLite transaction-based saving, SQLite loading ordered by post ID, and two additional tests. I reviewed the suggestions and applied the relevant changes to my project.
Key parts of the accepted implementation:
```dart
final posts = await fetchFromNetwork();
await cache.save(posts);
return PostsResult(posts, fromCache: false);
```
```dart
final cached = await cache.load();
if (cached.isNotEmpty) {
  return PostsResult(cached, fromCache: true);
}
rethrow;
```
.

## Rejected suggestion(s) — at least one
An earlier repository suggestion used `cache.savePosts(posts)` and `cache.getPosts()`. I did not keep those method calls because the instructor-provided `PostCache` interface defines `Future<void> save(List<Post> posts)` and `Future<List<Post>> load()`. Instead, I used `await cache.save(posts)` and `await cache.load()` so the implementation matches the supplied interface without changing the starter code.
I also did not replace SQLite with `MemoryPostCache` for the final Android app, because an in-memory cache would not preserve posts after the app restarted.


## Verification

I verified the AI-assisted implementation through automated testing, static analysis, code review, and manual testing.

**Automated testing:** I ran `flutter test`, and all 16 tests passed, including the instructor-provided tests and my additional tests.
 **Static analysis:** I ran `flutter analyze`, which reported `No issues found!` in 2.2 seconds.
 **Manual testing:** I successfully ran the Campus Feed application on my Android phone. With internet access enabled, the application loaded posts from the API. After disabling internet access and reopening the application, the saved posts appeared with the message `Offline - showing saved posts`.
 **Code review:** I reviewed the AI-generated implementation against the lab instructions and corrected the repository to use the `save()` and `load()` methods defined in `PostCache`.


## What I learned
I learned that the repository must await asynchronous cache operations and that a transaction can keep SQLite cache updates consistent. I also learned to verify AI-generated method names against the instructor's provided interfaces instead of assuming a suggestion is correct.
