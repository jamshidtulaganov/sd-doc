import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import styles from './index.module.css';

const PROJECTS = [
  {
    label: 'sd-main',
    sublabel: 'Dealer CRM',
    href: '/docs/sd-main',
    summary:
      'Per-dealer CRM. Yii 1.x · multi-tenant · mobile + web + B2B online. Orders, agents, warehouse, payments, GPS, audits, integrations with 1C / Didox / Faktura.uz.',
    bullets: [
      '40+ Yii modules',
      '4 API surfaces (api, api2, api3 mobile, api4 online)',
      'DB-per-customer, subdomain-routed',
    ],
  },
  {
    label: 'sd-cs',
    sublabel: 'HQ Country Sales',
    href: '/docs/sd-cs/overview',
    summary:
      'Brand-owner / HQ application. Read-only consolidates across many sd-main databases via a swappable second connection. Pivot analytics, RFM, cross-dealer reports.',
    bullets: [
      'Two MySQL connections (own cs_* + dealer d0_*)',
      '30+ consolidated reports',
      'Read-only against dealer DBs by design',
    ],
  },
  {
    label: 'sd-billing',
    sublabel: 'Subscriptions & licensing',
    href: '/docs/sd-billing/overview',
    summary:
      'Platform-vendor subscription system. Pushes licence files to every sd-main, runs settlement and dunning, integrates with Click / Payme / Paynet / MBANK / P2P.',
    bullets: [
      '13 modules · Yii 1.1.15',
      'Cron-driven settlement + notifications',
      'Idempotent gateway transactions',
    ],
  },
];

const QUICK_LINKS = [
  {
    title: 'Architecture',
    items: [
      { label: 'Ecosystem · 3-project map', href: '/docs/ecosystem' },
      {
        label: 'Inter-project integration map',
        href: '/docs/ecosystem#inter-project-integration-map',
      },
      {
        label: 'Key feature catalog',
        href: '/docs/ecosystem#key-feature-catalog-by-project',
      },
      { label: 'Diagram gallery', href: '/docs/diagrams' },
    ],
  },
  {
    title: 'Build & ship',
    items: [
      { label: 'API reference', href: '/docs/api/overview' },
      { label: 'Frontend overview', href: '/docs/frontend/overview' },
      { label: 'Deployment', href: '/docs/devops/deployment' },
      { label: 'Contribution', href: '/docs/quality/contribution' },
    ],
  },
  {
    title: 'Get oriented',
    items: [
      { label: 'New developer onboarding', href: '/docs/team/onboarding' },
      { label: 'Workflow design standards', href: '/docs/team/workflow-design' },
      { label: 'Diagram inventory', href: '/docs/diagrams-inventory' },
      { label: 'Troubleshooting', href: '/docs/troubleshooting' },
    ],
  },
];

function Hero() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx('hero', styles.hero)}>
      <div className="container">
        <h1 className={styles.heroTitle}>{siteConfig.title}</h1>
        <p className={styles.heroTagline}>{siteConfig.tagline}</p>
        <p className={styles.heroLede}>
          Three sibling projects make up the platform — a dealer CRM (
          <code>sd-main</code>), an HQ aggregator (<code>sd-cs</code>), and a
          subscription / licensing service (<code>sd-billing</code>). This site
          is the developer documentation, organised project-first.
        </p>
        <div className={styles.heroCtas}>
          <Link className="button button--primary button--lg" to="/docs/intro">
            Read the docs
          </Link>
          <Link
            className="button button--secondary button--lg"
            to="/docs/ecosystem"
          >
            See the ecosystem
          </Link>
          <Link
            className="button button--outline button--lg"
            to="https://www.figma.com/board/y2kWMuxLwrpdaCGhVwYYYI"
          >
            Open the FigJam board
          </Link>
        </div>
      </div>
    </header>
  );
}

function ProjectCards() {
  return (
    <section className={styles.section}>
      <div className="container">
        <h2 className={styles.sectionTitle}>The three projects</h2>
        <p className={styles.sectionLede}>
          Pick the one you're working in. Each project's tree splits the same
          three ways: <strong>System Architecture</strong>,{' '}
          <strong>Workflows</strong>, <strong>Data Schemes</strong>.
        </p>
        <div className={styles.cardGrid}>
          {PROJECTS.map((p) => (
            <Link key={p.label} to={p.href} className={styles.card}>
              <div className={styles.cardHead}>
                <span className={styles.cardLabel}>{p.label}</span>
                <span className={styles.cardSublabel}>{p.sublabel}</span>
              </div>
              <p className={styles.cardSummary}>{p.summary}</p>
              <ul className={styles.cardBullets}>
                {p.bullets.map((b) => (
                  <li key={b}>{b}</li>
                ))}
              </ul>
              <span className={styles.cardCta}>Open project →</span>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

function QuickLinks() {
  return (
    <section className={clsx(styles.section, styles.sectionAlt)}>
      <div className="container">
        <h2 className={styles.sectionTitle}>Quick links</h2>
        <div className={styles.linksGrid}>
          {QUICK_LINKS.map((col) => (
            <div key={col.title} className={styles.linksCol}>
              <h3 className={styles.linksTitle}>{col.title}</h3>
              <ul className={styles.linksList}>
                {col.items.map((it) => (
                  <li key={it.label}>
                    <Link to={it.href}>{it.label}</Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.title}
      description={siteConfig.tagline}
    >
      <Hero />
      <main>
        <ProjectCards />
        <QuickLinks />
      </main>
    </Layout>
  );
}
