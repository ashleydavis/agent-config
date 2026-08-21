Publish a local runsheet markdown file under `runsheets/` to Confluence. Updates an existing page when the local file has a Confluence page id. Creates a new page when it does not.

Follow the runsheet style guide available in `~/notes` for how to publish (including TOC, titles, comments, and links).

**Do not use Python** (or other local converters) for this. Strip the metadata comment yourself, call the Atlassian MCP, then fix TOC and links with a second HTML update. No markdown→HTML scripts.

## Steps

1. **List local runsheets.** List every `*.md` under `runsheets/` (non-recursive unless the user asks). Present the list to the human and ask which file to publish. Stop if the directory is missing or empty.

2. **Read the local file and its Confluence metadata.** Prefer an HTML comment at the top of the form:

   ```html
   <!--
   Source: <Confluence page URL>
   Confluence page id: <pageId>
   Downloaded: YYYY-MM-DD
   Version at download: <n>
   -->
   ```

3. **Choose create vs update.**

   - **Update:** `Confluence page id` is present. Continue at step 4. If `Version at download` is missing, stop and tell the user to run `/runsheet/download` first (or acknowledge they accept overwrite risk).
   - **Create:** `Confluence page id` is missing. Continue at step 5. If the human instead supplies an existing Confluence URL or page id, treat it as an update (overwrite risk if there is no `Version at download`).

4. **Update an existing page. Conflict check (mandatory, do this before any write).** Using the Atlassian MCP (`getConfluencePage`):

   - Resolve `cloudId` via `getAccessibleAtlassianResources` if needed.
   - Fetch the live page by `pageId`.
   - Compare live `version.number` to local `Version at download`.
   - **If live version is greater than `Version at download`, STOP.** Report both version numbers, the live page URL, who last updated if available, and that publishing would overwrite newer Confluence edits. Do not update the page. Suggest `/runsheet/download` to refresh the local copy, then re-apply local edits.
   - If versions are equal, or live is older/equal to the recorded download version, continue.

   Then publish the markdown. Strip only the local metadata HTML comment (and any leading `# Title` / `DO NOT PUBLISH` blocks per the style guide). Call `updateConfluencePage` with:
   - `contentFormat: "markdown"`
   - `pageId` from the local metadata
   - the remaining markdown as `body`
   - a short `versionMessage` (e.g. `Updated from local runsheets/<file>`)
   - `title` only when renaming

   Continue at step 6.

5. **Create a new page** (local file has no Confluence page id).

   - Title is the local `#` heading. Stop if there is no H1.
   - Ask for the Confluence **space** (key or URL) and **parent page** (URL, page id, or title to search). Do not guess either. Omit `parentId` only when the human says the page should sit at the space root. If they give a parent URL or id, you may take `spaceId` from that parent instead of asking for the space separately.
   - Resolve `cloudId` via `getAccessibleAtlassianResources` if needed.
   - Confirm the space (`getConfluenceSpaces` with `keys`, or from the parent page). Resolve a parent title with `searchConfluenceUsingCql`; resolve a parent URL or id with `getConfluencePage`.
   - **Duplicate-title check.** Search `title = "<H1>" AND type = page AND space = <KEY>`. If a page already has that title, STOP and ask whether to update that page (then step 4) or create anyway.
   - Strip any local metadata HTML comment, the leading `# Title`, and any `DO NOT PUBLISH` blocks per the style guide.
   - Call `createConfluencePage` with:
     - `contentFormat: "markdown"`
     - `spaceId` (space key is accepted)
     - `title` from the local H1
     - the remaining markdown as `body`
     - `parentId` when nesting
     - `status: "current"`
   - Take `pageId`, `version.number`, and `webUrl` from the response. Continue at step 6 with that `pageId`.

6. **Fix TOC and clickable links (HTML pass).** Markdown create/update drops the Confluence TOC macro and leaves ordinary anchors that are not smart links. Immediately:
   1. `getConfluencePage` with `contentFormat: "html"`.
   2. Ensure a TOC macro is at the top of the body (insert if missing):

      ```html
      <div data-type="extension" data-extension-key="toc" data-extension-type="com.atlassian.confluence.macro.core"></div>
      ```

   3. On every content link (`<a href="...">`), set `data-card-appearance="inline"` so Confluence renders clickable smart links. Also turn bare ticket examples that should be links into `<a href="..." data-card-appearance="inline">…</a>` when appropriate.
   4. `updateConfluencePage` with `contentFormat: "html"`, the adjusted body, and a short `versionMessage` (e.g. `Restore TOC and inline smart links`).

   Do this with the MCP only. Do not shell out to converters.

7. **Refresh local metadata.** After the HTML pass succeeds, fetch the page again and rewrite the local file's top HTML comment with `Source`, `Confluence page id`, `Downloaded` date (today), and `Version at download`. Insert the comment if the file did not have one (new pages). Do not change the runsheet body in that rewrite except the comment.

8. **Open for review.** Open the Confluence page URL in a new Google Chrome window: `google-chrome --new-window <page-url>`

9. **Report.** Give the Confluence page URL, whether the page was created or updated, and the new version number.

## Hard stops

- Never publish if Confluence is ahead of `Version at download`.
- Never invent a page id, space, or parent; they must come from local metadata or the human (or from the `createConfluencePage` response after a successful create).
- Never create a page whose title already exists in the space without asking.
- Never use Python (or similar) to convert markdown to HTML for this command.
