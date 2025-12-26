# Code Review Checklist: Recipe Add Workflow with Ingredients, Steps, and Images

- [ ] Codegen artifacts updated (build_runner)
- [ ] Tests green (`flutter test`)
- [ ] Analyzer clean (`flutter analyze`)
- [ ] No hardcoded secrets/API keys
- [ ] Offline paths verified (local persistence, image refs)
- [ ] Async safety: no updates after dispose; `ref.mounted` checked
- [ ] Image limits enforced (count and size) with user feedback
- [ ] Validation guards title + ingredient requirement
- [ ] Docs updated (quickstart, research notes)
