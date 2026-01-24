# Agent Guidelines for Heric's Hugo Site

## Build Commands

**Development Server (with drafts):**
```bash
nix develop  # Enter development shell
hserve       # Alias for: hugo server -D
```
Access at `http://localhost:1313`. Changes auto-reload.

**Production Build:**
```bash
hbuild       # Alias for: hugo
hugo --minify  # Minified production build
```

**Clean Generated Artifacts:**
```bash
hclean       # Removes public/ directory
rm -rf public/ resources/_gen/ result/
```

**Nix Build (CI/CD):**
```bash
nix build --print-out-paths
# Output goes to ./result/
```

**Testing:**
```bash
npm test     # Echoes "Error: no test specified"
# No test framework is configured
```

## Project Structure

```
/home/hc/Documentos/herijooj.github.io/
├── content/          # Bilingual page bundles (en + .pt-br.md)
│   ├── posts/        # Blog posts with images alongside
│   ├── projects/     # Project entries
│   └── ...
├── layouts/          # Custom templates overriding theme
├── assets/scss/      # SCSS source files
│   ├── main.scss     # Entry point with imports
│   ├── components/   # Component styles
│   └── ...
├── themes/notepad/   # Theme submodule
├── hugo.toml         # Site configuration
├── i18n/             # Localization (en.toml, pt-br.toml)
└── flake.nix         # Nix development environment
```

## Content Guidelines

**Bilingual Content:**
- English files: no suffix (e.g., `index.md`)
- Portuguese translations: `.pt-br.md` suffix
- Use matching `translationKey` values for Hugo's linking
- Keep same `date` values in front matter for consistent ordering

**Front Matter:**
```yaml
---
title: "Page Title"
date: 2024-01-24
translationKey: "unique-key"
# Optional fields:
titlebar: "Custom Window Title"
slug: "custom-url-slug"
gallery: []
technologies: []
---
```

**New Content via Archetypes:**
```bash
hugo new --kind posts posts/my-slug/index.md
hugo new --kind projetos projects/my-project/index.md
```

**Images:**
- Place images alongside content in page bundles
- Hugo auto-generates responsive WebP variants via custom renderer
- Global static assets (avatars, GIFs): `static/` directory
- Use absolute paths for static assets: `/image.gif`

## Styling (SCSS)

**Adding New Styles:**
1. Create partial in `assets/scss/components/` or `utilities/`
2. Import in `assets/scss/main.scss`
3. Hugo pipes compile via `partials/head.html`

**SCSS Organization:**
```
assets/scss/
├── main.scss           # Entry point
├── config/             # Variables, mixins
├── base/               # Reset, typography
├── components/         # Navigation, content, etc.
├── layout/             # Page structure
└── utilities/          # Responsive helpers
```

## Hugo Templates

**Layout Override Priority:**
- `layouts/` overrides `themes/notepad/layouts/`
- `baseof.html` sets the page frame
- Specialized blocks: `index.html`, `posts/single.html`, `projetos/single.html`

**Navigation:**
- Defined in `hugo.toml` under `[languages.*.menu]`
- Language switcher auto-detects translations
- Partial: `themes/notepad/layouts/partials/navigation.html`

**Shortcodes:**
- Use `{{< relref "../path" >}}` for internal links (respects `relativeURLs`)

## Localization (i18n)

- UI labels: `i18n/en.toml` and `i18n/pt-br.toml`
- Add new `id` entries when partials reference `i18n` keys
- Front matter `titlebar` fallback in `site-header.html`

## Generated Artifacts (Do Not Edit)

- `public/` - Hugo output
- `resources/_gen/` - Generated resources
- `result/` - Nix build output

Clean before committing regenerated outputs.

## Code Style

**General:**
- Follow existing patterns in the codebase
- Avoid modifying theme files directly; override in `layouts/`
- Keep content files (Markdown) simple and readable

**Front Matter:**
- Use consistent YAML formatting
- Dates: `YYYY-MM-DD` format
- `translationKey` must match between translations

**Hugo Config:**
- Prefer shortcodes over raw HTML in Markdown
- Use `relref` for internal navigation
- Update both language menus when adding nav items

**SCSS:**
- Organize in modular partials
- Follow BEM-like naming for components
- Use variables from `config/_variables.scss`

**Commit Practices:**
- Clean generated directories before committing
- Keep commits focused on content or configuration changes
- Review `public/` changes before pushing
