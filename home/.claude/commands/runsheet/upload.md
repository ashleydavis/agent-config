Upload a local runsheet markdown file under `runsheets/` to its Confluence page.

Follow the runsheet style guide available in `~/notes` for how to publish (including TOC, titles, comments, and links).

**Do not use Python** (or other local converters) for this. Strip the metadata comment yourself, call the Atlassian MCP, then fix TOC and links with a second HTML update. No markdown→HTML scripts.

## Steps

1. **List local runsheets.** List every `*.md` under `runsheets/` (non-recursive unless the user asks). Present the list to the human and ask which file to upload. Stop if the directory is missing or empty.

2. **Read the local file and its Confluence metadata.** Prefer an HTML comment at the top of the form:

   ```html
   <!--
   Source: <Confluence page URL>
   Confluence page id: <pageId>
   Downloaded: YYYY-MM-DD
   Version at download: <n>
   -->
   ```

   Require at least `Confluence page id` and `Version at download`. If either is missing, stop and tell the user to run `/runsheet/download` first (or supply the page id and acknowledge they accept overwrite risk).

3. **Conflict check (mandatory, do this before any write).** Using the Atlassian MCP (`getConfluencePage`):

   - Resolve `cloudId` via `getAccessibleAtlassianResources` if needed.
   - Fetch the live page by `pageId`.
   - Compare live `version.number` to local `Version at download`.
   - **If live version is greater than `Version at download`, STOP.** Report both version numbers, the live page URL, who last updated if available, and that uploading would overwrite newer Confluence edits. Do not update the page. Suggest `/runsheet/download` to refresh the local copy, then re-apply local edits.
   - If versions are equal, or live is older/equal to the recorded download version, continue.

4. **Upload the markdown.** Strip only the local metadata HTML comment (and any leading `# Title` / `DO NOT PUBLISH` blocks per the style guide). Call `updateConfluencePage` with:
   - `contentFormat: "markdown"`
   - `pageId` from the local metadata
   - the remaining markdown as `body`
   - a short `versionMessage` (e.g. `Updated from local runsheets/<file>`)
   - `title` only when renaming

5. **Fix TOC and clickable links (HTML pass).** Markdown upload drops the Confluence TOC macro and leaves ordinary anchors that are not smart links. Immediately:
   1. `getConfluencePage` with `contentFormat: "html"`.
   2. Ensure a TOC macro is at the top of the body (insert if missing):

      ```html
      <div data-type="extension" data-extension-key="toc" data-extension-type="com.atlassian.confluence.macro.core"></div>
      ```

   3. On every content link (`<a href="...">`), set `data-card-appearance="inline"` so Confluence renders clickable smart links. Also turn bare ticket examples that should be links into `<a href="..." data-card-appearance="inline">…</a>` when appropriate.
   4. `updateConfluencePage` with `contentFormat: "html"`, the adjusted body, and a short `versionMessage` (e.g. `Restore TOC and inline smart links`).

   Do this with the MCP only. Do not shell out to converters.

6. **Refresh local metadata.** After the HTML pass succeeds, fetch the page again and rewrite the local file's top HTML comment with the new `Version at download`, `Downloaded` date (today), and Source URL. Do not change the runsheet body in that rewrite except the comment.

7. **Open for review.** Open the Confluence page URL in a new Google Chrome window: `google-chrome --new-window <page-url>`

8. **Report.** Give the Confluence page URL and the new version number.

## Hard stops

- Never upload if Confluence is ahead of `Version at download`.
- Never invent a page id; it must come from local metadata or the human.
- Never use Python (or similar) to convert markdown to HTML for this command.
