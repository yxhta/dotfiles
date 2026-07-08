---
name: summarize-ai-news
description: Extract and summarize AI-related topics from target news sites, RSS feeds, Hacker News, or supplied article URLs, with optional append-to-Notion delivery. Use when the user asks for an AI news digest, a "what to watch" briefing, a trend summary from specific sources/domains, or to add the digest to a configured Notion page, especially for current or recent items that require web verification.
---

# AI News Topic Briefing

## Inputs

- Identify target sites, domains, feeds, or URLs from the user request.
- If no source is specified, use the default source: Hacker News (`https://news.ycombinator.com/`). Include linked original articles and HN discussion pages when available.
- Use the requested timeframe when provided. If none is provided, default to the last 24 hours for a daily digest and the last 7 days for sparse sources.
- Default output language is Japanese. Keep source names, article titles, product names, model names, commands, and URLs in their original language.
- If Notion delivery is requested or enabled, read `config/notion.toml` in this skill directory, then apply `config/notion.local.toml` overrides if that file exists. Store only non-secret Notion page metadata there; never put API tokens or credentials in the repo.

## Collection Workflow

1. Browse current source pages, feeds, or domain-restricted search results. News is time-sensitive; verify dates before summarizing.
2. For Hacker News, use both the HN discussion page and the original linked article when available. Treat HN comments as discussion signals, not factual sources.
3. Prefer primary sources for factual claims: company blogs, papers, standards/specs, official changelogs, court/regulatory documents, or the original reporting outlet.
4. Gather more candidates than the final limit, then deduplicate stories that point to the same underlying event.
5. Read enough of each source to understand the actual change. Do not summarize from titles alone.

## Notion Append Workflow

Use this workflow when the user explicitly asks to write to Notion or `config/notion.toml` has `enabled = true`.

1. Read `config/notion.toml` from this skill directory. If `config/notion.local.toml` exists, merge it over the base config. Supported keys are `enabled`, `target_page`, `target_mode`, `position`, `heading_template`, and `timezone`. `target_mode` defaults to `append`; use `daily_child_page` to treat `target_page` as a parent page and write into a `YYYY/MM/DD` child page.
2. Resolve the destination from the user request first, then `target_page`. If no Notion page URL or ID is available, ask for the destination before writing. Do not invent a page.
3. Use the Notion app/connector for access. If Notion tools are unavailable, tell the user to connect the Notion app and return the digest in chat without pretending it was written.
4. Fetch the target page before updating it to verify access and resolve the page ID.
5. If `target_mode = "daily_child_page"`, treat the resolved target as a parent page. Use the configured timezone to derive today's `YYYY/MM/DD` title, reuse an existing child page with that exact title when present, or create it under the parent page when absent. Write the digest to that child page instead of the parent page.
6. Convert the final digest into Notion-flavored Markdown:
   - Use a level-2 heading built from `heading_template`.
   - Include the one-sentence takeaway.
   - Add one subsection per topic with "What happened", "Why it matters", "What to watch", and "Sources".
   - Keep source links inline and avoid long quotes.
7. Append with the available Notion update-page tool using `command: "insert_content"`, the generated `content`, and `position` (`"end"` unless configured otherwise) on the resolved destination page. If the environment only exposes search-and-replace content updates, fetch the page first and append by replacing a stable exact snippet. Do not use destructive whole-page replacement unless the user explicitly asks.
8. After a successful update, mention the Notion page in the final response and keep the chat digest compact. If the update fails, explain the failure and provide the content that would have been appended.

## AI Relevance Filter

Include items with clear AI impact, such as:

- model releases, benchmarks, evals, training/inference techniques, and dataset issues
- agents, coding assistants, MCP/A2A/tool protocols, workflow automation, and developer tooling
- AI infrastructure, chips, datacenters, inference cost, observability, and reliability
- safety, security, abuse, privacy, copyright, policy, and regulation
- major product launches or enterprise adoption with technical or market implications

Exclude or down-rank:

- generic fundraising, partnerships, or marketing with no technical or strategic signal
- duplicate rewrites of the same announcement
- low-confidence rumors without a trustworthy source
- broad opinion pieces unless they reveal a concrete industry shift or strong HN debate

## Ranking Heuristics

Prioritize topics by:

1. developer or operator impact
2. novelty versus routine release notes
3. strategic importance for AI labs, platforms, open source, or regulation
4. source credibility and specificity
5. discussion quality or controversy on the target site
6. actionability: something the user should read, try, monitor, or avoid

## Synthesis Rules

- Separate verified facts from inference and community sentiment.
- Use absolute dates for time-sensitive claims.
- Mention uncertainty directly when sources disagree or the evidence is thin.
- Avoid long quotes. Paraphrase and link to the source.
- Include source links inline for each topic. When the environment supports citations, cite the pages used.
- Keep the final digest tight: usually 5-8 topics, unless the user asks for more.

## Output Shape

Start with a one-sentence overall takeaway, then list topics in priority order.

For each topic include:

- topic title
- what happened
- why it matters
- what to watch next or what action to take
- source links

End with a short "dropped or low-confidence" note only when it helps explain notable omissions.
