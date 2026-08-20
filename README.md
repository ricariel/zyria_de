# zyria.de Website

Source of the [zyria.de](https://zyria.de) website, a personal blog and
knowledge base built with [Hugo](https://gohugo.io/). The content is a public
notebook — mostly homelab, networking, Kubernetes and solar energy — written in
German.

## Technologies Used

- **[Hugo](https://gohugo.io/)** — static site generator, written in Go
- **[Node.js / npm](https://nodejs.org/)** — front-end build tooling, PostCSS
  with Autoprefixer

## Requirements

- **Hugo, extended build**, at least 0.122.0 — `module.toml` enforces the
  minimum. See the [installation guide](https://gohugo.io/installation/); the
  plain build cannot compile the theme's SCSS.
- **Node.js and npm**, for the PostCSS toolchain
- Access to the forge hosting the private Hugo modules

## Local Development

```bash
npm install
hugo mod get -u ./...
hugo server
```

The site is then served at `http://localhost:1313/`.

Production build:

```bash
hugo --minify
```

Output lands in `public/`.

## Configuration

Configuration is split across `config/_default/` rather than a single file:

| File | Contents |
| --- | --- |
| `hugo.toml` | Base URL, taxonomies, pagination, outputs, related-content indices |
| `module.toml` | Hugo version requirement, mounts and module imports |
| `params.toml` | Theme options: appearance, search, code copy, TOC, repository links |
| `languages.de.toml` | Language, site title, author profile and social links |
| `menus.de.toml` | Navigation |
| `markup.toml` | Goldmark and syntax highlighting |
| `minify.toml`, `build.toml`, `security.toml` | Build behaviour |
| `frontmatter.toml` | Date handling in front matter |

## Modules

The theme is [Blowfish](https://blowfish.page/), pulled in as a module — there is
no `themes/` directory. Alongside it:

| Module | Purpose |
| --- | --- |
| `hugo-shortcodes` | Own shortcodes |
| `hugo-default-coder` | Shared assets, favicons and partials |
| `hugo-legal` | Imprint and privacy policy, mounted into `content/` |
| `hugomods/shortcodes` | Additional shortcodes |
| `k3s-prod` | Cluster documentation, mounted into the homelab section |

The `k3s-prod` import is the notable one: the cluster repository's own `README.md`
and every `apps/*/README.md` are mounted under
`content/posts/homelab/k3s-prod/`. The cluster documentation is therefore written
once, in the repository it documents, and published here without being copied.

A consequence worth remembering: **anything written into a `README.md` in
`k3s-prod` is published on this site.** Treat those files as public documents.

After changing module imports, run `hugo mod get -u ./...` so `go.mod` and
`go.sum` are updated.

## Content

Everything lives in `content/`, with `content/posts/` split into sections
(`homelab`, `solar`, …). Sections nest, and each carries an `_index.md`.

Some directories contain scripts and configuration files next to the Markdown.
These are page resources: articles link to them so a snippet can be downloaded
verbatim rather than copied out of a code block.

`refLinksErrorLevel = 'ERROR'` makes a broken `ref`/`relref` fail the build
instead of quietly producing a dead link.

## Deployment

`.forgejo/workflows/hugo.yaml` builds the site on every push to `main` or
`master` and pushes the result to this repository's `pages` branch, which
Forgejo Pages serves.

The remaining workflows:

| Workflow | Purpose |
| --- | --- |
| `hugo-mod-update.yaml` | Updates the Hugo modules |
| `renovate.yaml` | Dependency updates |
| `calver-tag.yaml` | Weekly CalVer tag |
| `pre-commit.yaml` | Lint and style checks |
| `mirror_codeberg.yaml`, `mirror_github.yaml` | Push mirrors |

Because the cluster documentation arrives through a module, the site changes
without a commit in this repository. The module update workflow is what carries
those changes in.

## Contributing

Bug reports and suggestions are welcome — open an issue or send a pull request.
`pre-commit` runs the style checks before a commit lands.

## License

See [LICENSE](LICENSE).
