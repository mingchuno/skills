---
name: js-ts-project-scaffolding
description: Choose a minimal stack and scaffold a new JavaScript or TypeScript Node.js or web project. Use only when creating a new project, not for existing-project changes or routine feature work.
---

# JS/TS project scaffolding

Use the user's choices first. Treat these as defaults, and add a library only when the project needs the capability. Check current documentation and compatibility before selecting versions or generating setup commands.

- **Tooling:** TypeScript 7+ for TypeScript projects, Biome, pnpm, and mise for runtime and tool versions. Enable strict type checking.
- **Web framework:** Prefer TanStack Start over Next.js when a full-stack React framework is warranted. Add TanStack Query for client-side server-state needs and TanStack Form for nontrivial forms; use framework and native facilities when sufficient.
- **Validation and config:** Use Zod at untrusted-data boundaries. Use t3-env when environment variables need a typed, validated contract.
- **Data:** Choose SQLite for simple local or modest single-instance storage, PostgreSQL when concurrency, scale, or deployment needs justify it. Prefer Drizzle for schema, migrations, and queries. Use parameterized raw SQL for patterns Drizzle cannot express; never interpolate values into SQL strings.
- **Styling:** Use CSS Modules for small projects and Tailwind CSS for medium-sized projects. Keep global CSS limited to resets, tokens, and truly global rules. Add shadcn/ui or Base UI only when a component library or design-system foundation is needed.

Before scaffolding, establish the project shape (CLI, service, static site, or full-stack app), deployment target, and data needs. Choose a latest Node.js LTS version. Include only the smallest useful checks: typecheck, Biome, and tests for meaningful behavior. Add authentication, CI, observability, or other infrastructure only when requirements call for them.
