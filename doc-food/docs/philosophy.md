# Philosophy

The following design goals drive `wb` development:

- :deciduous_tree: Filesystem tree [[layout root|input]] directly translates to the [[build root|output]] website structure
- :heavy_minus_sign: No bundled JavaScript
- :iphone: Minimal mobile-first output - it's up to the user to tweak/change the [[templates|design]].
  Only basic HTML/CSS knowledge should be required.
- :penguin: Good unix citizen - no build pipelines provided out of the box; no built-in
  web server, no deployment helpers. The workflow can be [[usage|combined]] with standard
  ecosystem tools.
- :book: Emphasis on [[docs|documentation]]

> :eyes: See also: [[use cases]]
