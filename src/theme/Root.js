import React from 'react';
import { useLocation } from '@docusaurus/router';
import { AuthProvider, useAuth } from '@site/src/auth/AuthContext';
import { isRestricted } from '@site/src/auth/permissions';
import LoginScreen from '@site/src/components/LoginScreen';
import AccessDenied from '@site/src/components/AccessDenied';
import AuthToolbar from '@site/src/components/AuthToolbar';

function Gate({ children }) {
  const { user, canView, hydrated } = useAuth();
  const location = useLocation();

  // During SSR / first paint render an empty shell so the static HTML is
  // not the actual docs content (small obfuscation; not security).
  if (!hydrated) {
    return <div className="rbac-loading" aria-hidden="true" />;
  }

  if (!user) {
    return <LoginScreen />;
  }

  if (!canView(location.pathname)) {
    return (
      <>
        <AuthToolbar />
        <AccessDenied restricted={isRestricted(location.pathname)} />
      </>
    );
  }

  return (
    <>
      <AuthToolbar />
      {children}
    </>
  );
}

export default function Root({ children }) {
  return (
    <AuthProvider>
      <Gate>{children}</Gate>
    </AuthProvider>
  );
}
