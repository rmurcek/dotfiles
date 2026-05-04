---
name: design-system
description: Use when making any frontend changes involving colors, theming, button variants, component styling, typography, or UI component creation. Automatically loads the Stepful Design System (SDS) tokens, components, and conventions.
allowed-tools: Read, Grep, Glob
---

Load the Stepful Design System (SDS) context before making frontend styling, theming, or component changes.

## Steps

1. Read the design system overview and rules:

   - `app/javascript/lib/theme/README.md`
   - The "Chakra UI & Stepful Design System (SDS)" section in `docs/coding-standards/typescript-react.md`

2. Read the foundational token definitions to know what's available:

   - `app/javascript/lib/theme/foundations/colors.ts` — all semantic color tokens (`sds.fill.*`, `sds.text.*`, `sds.border.*`, `sds.icon.*`, etc.)
   - `app/javascript/lib/theme/foundations/typography.ts` — all `textStyle` tokens (`bodySM`–`bodyXL`, `headlineXS`–`headlineXL`, `displaySM`–`displayXL`, etc.)
   - `app/javascript/lib/theme/foundations/radii.ts` — border radius tokens
   - `app/javascript/lib/theme/constants.ts` — `TOKEN_PREFIX`, business mode selector constants

3. Read the SDS component implementations:

   - `app/javascript/lib/theme/recipes.ts` — `defineRecipe` / `useRecipe` pattern (Chakra v3 port for v2)
   - `app/javascript/components/ui/button.tsx` — SDS Button with all variants and sizes
   - `app/javascript/components/ui/badge.tsx` — SDS Badge with colorPalettes and variants
   - `app/javascript/components/typography/index.ts` — `H1`–`H6` heading wrappers
   - `app/javascript/components/ui/input.tsx` and `app/javascript/components/ui/input-group.tsx` - SDS input field component with two size options and input group components to group and input with form label, error message and helper text
   - `app/javascript/components/ui/form-label.tsx`, `app/javascript/components/ui/form-helper-text.tsx`, `app/javascript/components/ui/form-error-message.tsx` - auxilliary components for label form fields and giving feedback

4. Apply these principles when making changes:
   - **⛔ NEVER modify `app/javascript/lib/theme/foundations/colors.ts` without explicit user confirmation.** This file defines all SDS color tokens and is shared across the entire application. Changes to it are rare and deliberate. If you think a change is needed, **stop and ask the user first** — explain what you want to change and why.
   - **Always use semantic SDS color tokens** (e.g. `sds.fill.brandMuted`) — never legacy Chakra colors (`blue.500`) or hardcoded hex values
   - **Use SDS component imports** from `~/components/ui` when available — don't override `colorScheme` on design system button variants
   - **Use `textStyle` prop** for typography — not raw `fontSize`/`fontWeight` combinations
   - **Respect business/consumer modes** — semantic tokens auto-resolve; don't hardcode values that should differ between modes
   - **Use `satisfies ColorToken`** when typing color values inline for type safety
   - **New components** should use `defineRecipe` pattern (see `recipes.ts`)
