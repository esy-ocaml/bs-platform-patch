# `@esy-ocaml/bs-platform`
Configuration for bs-platform.

This is just the `esy.json` configuration that can be overlaid on top of bs-platform releases.
What this accomplishes:

1. Makes `bs-platform` build faster, in the event that you already built an ocaml compiler in the build cache.
2. Makes `bs-platform` install instantly if you've ever installed it in the past. Avoids using npm link to get around rebuilding issues.
3. Enables relocatability of `bs-platform`.

To use this to create another release:
1. Download a released version of `bs-platform`.
2. copy `esy.json` into the release.
3. Change the `name` field of the `package.json` file to `"@esy-ocaml/bs-platform"`.
4. Then run `npm publish`.
