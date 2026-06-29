---
description: Extract AI topics from news sites and summarize what to watch
argument-hint: SITES="news.ycombinator.com" TIMEFRAME="24h" FOCUS="" LIMIT=8
---

Use $$summarize-ai-news to extract and summarize AI-related topics from the target news sites.

User-supplied arguments: $ARGUMENTS

Interpret optional arguments as:

- SITES: comma-separated domains, news sites, feeds, or URLs to inspect. If omitted, use `news.ycombinator.com`.
- TIMEFRAME: time window such as "24h", "today", "this week", or an explicit date range.
- FOCUS: optional emphasis such as "developer tooling", "agents", "regulation", "infra", or "Japan".
- LIMIT: approximate number of final topics.

If SITES is absent and the conversation does not already name target sources, inspect Hacker News (`news.ycombinator.com`) by default. Produce the summary in Japanese by default.
