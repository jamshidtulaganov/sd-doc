// Role -> allowed URL path prefixes.
//
// Access decision order:
//   1. Superadmin sees everything (sentinel '*').
//   2. Otherwise, if the path is in RESTRICTED_PATHS, deny — superadmin-only
//      content (secrets, attacker playbooks, internal infra, real
//      credentials, tenant-enumeration recipes, etc.). Classified by a
//      multi-agent senior-architect audit.
//   3. Otherwise, allow if the path is in ALWAYS_ALLOWED, or matches one
//      of the role's allowed prefixes.
//
// Sidebar entries whose href fails this check are hidden by the
// DocSidebarItems swizzle.

const ALWAYS_ALLOWED = [
  '/',
  '/login',
  '/docs/intro',
  '/docs/ecosystem',
  '/docs/troubleshooting',
  '/docs/changelog',
];

// Pages with sensitive content — only superadmin may view.
// Paths are URL pathnames (no .md extension). Locale prefix is stripped
// before matching, so this also covers /ru/... and /uz/... routes.
const RESTRICTED_PATHS = [
  // ── sd-billing ─────────────────────────────────────────────
  '/docs/sd-billing/security-landmines',  // critical-vuln playbook
  '/docs/sd-billing/auth-and-access',     // auth weaknesses enumerated
  '/docs/sd-billing/api-reference',       // full attack surface + hard-coded tokens
  '/docs/sd-billing/notifications',       // internal bot proxy IP + chat IDs
  '/docs/sd-billing/integration',         // prod IP allow-list
  '/docs/sd-billing/local-setup',         // real seed credentials
  '/docs/sd-billing/modules',             // pointers to live vulnerabilities
  '/docs/sd-billing/workflows/api-click', // HMAC signing recipe + real merchant id

  // ── sd-cs ──────────────────────────────────────────────────
  '/docs/sd-cs/local-setup',
  '/docs/sd-cs/architecture',
  '/docs/sd-cs/sd-main-integration',
  '/docs/sd-cs/multi-db',
  '/docs/sd-cs/workflows/report-plan',
  '/docs/sd-cs/workflows/report-sale',
  '/docs/sd-cs/workflows/report-inventory',
  '/docs/sd-cs/workflows/pivot-akb',
  '/docs/sd-cs/workflows/report-agent',
  '/docs/sd-cs/workflows',                // attack-surface index

  // ── cross-cutting security ─────────────────────────────────
  '/docs/security/sd-main-landmines',
  '/docs/security/overview',
  '/docs/security/auth-and-roles',
  '/docs/security/sessions',
  '/docs/security/rbac',
  '/docs/security/data-isolation',

  // ── devops / infra ─────────────────────────────────────────
  '/docs/devops/deployment',
  '/docs/devops/nginx',
  '/docs/devops/backup-and-restore',
  '/docs/devops/docker-compose',
  '/docs/devops/monitoring-logging',
  '/docs/devops/scaling',

  // ── integrations with concrete auth/secret disclosure ──────
  '/docs/integrations/1c-esale',
  '/docs/integrations/telegram',
  '/docs/integrations/fcm',
  '/docs/integrations/gps',

  // ── architecture / data / schema dumps ─────────────────────
  '/docs/architecture/cross-project-integration', // hard-coded prod TOKEN
  '/docs/architecture/multi-tenancy',
  '/docs/architecture/caching',
  '/docs/data/schema-reference',
  '/docs/data/migrations',
  '/docs/data/erd-real',
];

const PERMISSIONS = {
  superadmin: '*',

  'sd-billing': [
    '/docs/sd-billing',
    '/docs/billing',
    '/docs/diagrams/sd-billing',
  ],

  'sd-cs': [
    '/docs/sd-cs',
    '/docs/diagrams/sd-cs',
  ],

  // sd-main role: scoped to the "Workflows" branch of the sd-main sidebar.
  // The Workflows category bundles modules/, api/, integrations/, frontend/, ui/.
  'sd-main': [
    '/docs/sd-main',
    '/docs/modules',
    '/docs/api',
    '/docs/integrations',
    '/docs/frontend',
    '/docs/ui',
    '/docs/diagrams/sd-main-system',
    '/docs/diagrams/sd-main-features',
    '/docs/diagrams/workflows',
  ],

  // sd-mobile: there is no dedicated mobile section yet. For now the role
  // is scoped to the mobile API doc only. Extend this list as mobile-specific
  // pages are added (e.g. '/docs/mobile').
  'sd-mobile': [
    '/docs/api/api-v3-mobile',
  ],
};

function normalize(pathname) {
  if (!pathname) return '/';
  return pathname.length > 1 && pathname.endsWith('/')
    ? pathname.slice(0, -1)
    : pathname;
}

function stripLocale(pathname) {
  return pathname.replace(/^\/(ru|uz)(?=\/|$)/, '') || '/';
}

function isRestricted(pathname) {
  const path = normalize(stripLocale(pathname || '/'));
  return RESTRICTED_PATHS.some((p) => path === p || path.startsWith(p + '/'));
}

function hasAccess(role, pathname) {
  if (!role) return false;
  const path = normalize(stripLocale(pathname || '/'));

  if (PERMISSIONS[role] === '*') return true;

  // Restricted content is superadmin-only — checked AFTER the superadmin
  // bypass above, so a non-superadmin cannot reach it via any allowed prefix.
  if (isRestricted(path)) return false;

  if (ALWAYS_ALLOWED.some((p) => path === p || path.startsWith(p + '/'))) {
    return true;
  }

  const allowed = PERMISSIONS[role];
  if (!Array.isArray(allowed)) return false;

  return allowed.some((p) => path === p || path.startsWith(p + '/'));
}

function isSuperadmin(role) {
  return role === 'superadmin';
}

module.exports = {
  PERMISSIONS,
  ALWAYS_ALLOWED,
  RESTRICTED_PATHS,
  hasAccess,
  isRestricted,
  isSuperadmin,
};
