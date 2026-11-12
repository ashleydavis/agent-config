# Code comment rules

How comments in code are laid out and worded. This builds on `writing.md` and `communication.md`: follow both for every comment as well as the rules here.

## Layout

- Line comments with `//` preceded by blank line, method docs above function. Use `//` comments for method docs. Never use `///` doc comments or trailing comments on the same line as code. Wrap comments at 100 columns. Write every comment block with an empty `//` line above and below the text:

  ```
  //
  // <comment line 1>
  // ...
  // <comment line x>
  //
  ```

- Comments are sentences: a space after the slashes, a capital letter and a full stop (or a colon if they lead into what follows).

## What has a comment

- Every top-level function, variable and type has a comment block above it saying what it is for, what the intention is with it and why it is done this way rather than another way. Every field of a struct, interface or class has the same kind of comment. Comments state intent, not how the code works. Do not restate the type. Do not put a function's name in its own comment.

## Wording

- A function's comment opens with a verb saying what it does to what: "Converts the list of tags CloudFront returns into an object mapping each tag's key to its value", "Reads the pause record", "Builds the event". Never open with a noun phrase ("A template's tags as a record"), which reads as if the function were that thing.
- Then say why: what the result is for and who uses it ("so readTemplateName can look up the Distribution tag by name").
- Name the actual inputs, outputs and callers. Vague phrases such as "the way X reads them", "names nothing" or "handles the rest" make the reader open the code to find out what was meant.
- Comments describe the code as it is, never its history (what it used to be, what was removed or why it changed). History goes in the commit message.
