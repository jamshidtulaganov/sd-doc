import React from 'react';
import { Redirect } from '@docusaurus/router';

// The site has no homepage component — `/` redirects straight to the
// developer docs entry point. Header logo also targets /docs/intro so
// in normal use this file is unreachable; it exists for users typing
// the bare base URL.
export default function Home() {
  return <Redirect to="/docs/intro" />;
}
