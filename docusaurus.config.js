// @ts-check

const { themes } = require('prism-react-renderer');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'SalesDoctor Docs',
  tagline: 'Distribution & Sales Force Automation CRM — Developer Documentation',
  favicon: 'img/favicon.ico',

  url: 'https://docs.salesdoc.io',
  baseUrl: '/',

  organizationName: 'salesdoctor',
  projectName: 'sd-docs',

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'ru', 'uz'],
    localeConfigs: {
      en: { label: 'English', htmlLang: 'en' },
      ru: { label: 'Русский', htmlLang: 'ru' },
      uz: { label: "O'zbekcha", htmlLang: 'uz' },
    },
  },

  markdown: { mermaid: true },
  themes: ['@docusaurus/theme-mermaid'],

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          id: 'default',
          path: 'docs',
          routeBasePath: 'docs',
          sidebarPath: require.resolve('./sidebars.js'),
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/social-card.png',
      colorMode: { defaultMode: 'light', respectPrefersColorScheme: true },
      navbar: {
        title: 'SalesDoctor',
        logo: {
          alt: 'SalesDoctor',
          src: 'img/logo.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'developerSidebar',
            position: 'left',
            label: 'Developer Docs',
          },
          {
            href: 'https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj',
            label: 'Diagrams',
            position: 'right',
          },
          {
            type: 'localeDropdown',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              { label: 'Overview', to: '/docs/intro' },
              { label: 'Ecosystem', to: '/docs/ecosystem' },
              { label: 'API Reference', to: '/docs/api/overview' },
            ],
          },
          {
            title: 'Resources',
            items: [
              {
                label: 'FigJam diagrams',
                href: 'https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj',
              },
              { label: 'Changelog', to: '/docs/changelog' },
              { label: 'Troubleshooting', to: '/docs/troubleshooting' },
            ],
          },
        ],
        copyright: `© ${new Date().getFullYear()} Novus Distribution / SalesDoctor.`,
      },
      prism: {
        theme: themes.github,
        darkTheme: themes.dracula,
        additionalLanguages: ['php', 'bash', 'json', 'sql', 'yaml', 'nginx', 'docker'],
      },
      mermaid: {
        theme: { light: 'neutral', dark: 'dark' },
      },
    }),
};

module.exports = config;
