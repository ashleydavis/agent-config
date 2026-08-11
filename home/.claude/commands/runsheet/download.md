Download the latest Confluence runsheet into a local markdown file under `runsheets/`. Can create a new local file or refresh an existing one.

Follow the runsheet style guide available in `~/notes` for local mirror / publishing conventions.

## Steps

1. **Identify what to download.** Ask the human which applies:

   - **Refresh an existing local runsheet:** list every `*.md` under `runsheets/`, let them pick one, and use that file's `Confluence page id` / `Source` comment as the page to fetch. If the chosen file has no page id, ask for a Confluence URL or page id.
   - **Download a new / other Confluence page:** ask for a Confluence URL or page id, or a title / search string (use Atlassian MCP `searchConfluenceUsingCql` in the space they name).

   Confirm the chosen Confluence page (title + URL) before fetching.

2. **Fetch the page.** Using Atlassian MCP:

   - Resolve `cloudId` via `getAccessibleAtlassianResources` if needed.
   - `getConfluencePage` with `contentFormat: markdown` for a readable local body, and note `version.number`, title, and `webUrl` from the response.

3. **Choose the local path.**

   - **Refreshing an existing file:** use that same path.
   - **Otherwise:** default to `runsheets/<slug>.md` where `<slug>` is a short kebab-case name from the page title.

4. **Overwrite confirmation (mandatory when the target file already exists).**

   - If the destination path already exists, **stop and ask the human to confirm** they want to overwrite that local file with the latest Confluence content.
   - State clearly: the path that will be replaced, and that local edits not yet uploaded will be lost.
   - **Do not overwrite without an explicit yes.** If they decline, stop without writing (or ask for a different filename).

5. **Write the file** with this HTML comment header (required for `/runsheet/upload` conflict checks), then the markdown body from Confluence. Do not “improve” the procedure on download.

   ```html
   <!--
   Source: <webUrl>
   Confluence page id: <pageId>
   Downloaded: <YYYY-MM-DD>
   Version at download: <version.number>
   -->
   ```

   When refreshing, replace the whole file (new header + body) so `Version at download` matches Confluence.

6. **Report.** Local path, whether it was created or overwritten, page URL, and version number downloaded.
