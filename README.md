# `@esy-ocaml/bs-platform`
Configuration for bs-platform.

Note: (This is experimental, and just for fun, feel free to contribute and improve.)

This is just the `esy.json` configuration that can be overlaid on top of bs-platform releases.
What this accomplishes:

1. Makes `bs-platform` build faster, in the event that you already built an ocaml compiler in the build cache.
2. Makes `bs-platform` install instantly if you've ever installed it in the past. Avoids using npm link to get around rebuilding issues.
3. Enables relocatability of `bs-platform`.

To use this to create another release:
1. `./createRelease.sh`.
2. Verify the directory contents in current directory. This will be published to `npm`.
2. `npm publish`.


#### Versioning:
Since this `@esy-ocaml/bs-platform` is effectively a mirror of the
`bs-platform` npm releases, the versions should correspond with the
`bs-platform` `npm` versions. Since this is experimental, however, we want to
leave room to apply fixes to the mirror. The following versioning scheme allows
us to do so easily.


This versioning scheme shouldn't ever get in the way of a workflow, because
people should be depending on versions like `^2.0.0`, which will always grab
the minor/patch for that major version.
The need for a version mapping would be eliminated if `bs-platform` had an
`esy.json` file. The need for this mirror would entirely go away as well if
`bs-platform` included an `esy.json`.

`bs-platform` version | `@esy-ocaml/bs-platform` version | If we need to apply fixes to the mirror |
----------------------|----------------------------------|------------------------------------------
`2.0.0`               | `2.0.0`     | `2.0.1,` `2.0.2`, etc.
`2.0.1`               | `2.0.1000`  | `2.0.1001`, `2.0.1002` etc.
`2.3.0`               | `2.3.0`     | `2.3.1,`, `2.3.2`, etc.
`2.3.1`               | `2.3.1000`  | `2.3.1001,` `2.3.1002`, etc.

#### TODO:
- Create a similar `bsbnative` example.
- Create a similar `bsbnative` example with `@opam` dependencies.
- Consider checking in the `esy.json` into bs-platform to eliminate the need
  for this `@esy-ocaml/bs-platform` mirror entirely.
