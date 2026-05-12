import React from 'react';
import Link from '@docusaurus/Link';
import { useAuth } from '@site/src/auth/AuthContext';

export default function AccessDenied({ restricted = false }) {
  const { user, logout } = useAuth();

  return (
    <div className="rbac-denied">
      <div className={`rbac-denied-card ${restricted ? 'rbac-denied-card--restricted' : ''}`}>
        {restricted ? (
          <>
            <div className="rbac-denied-badge">RESTRICTED</div>
            <div className="rbac-denied-title">Superadmin-only content</div>
            <p className="rbac-denied-text">
              This page contains sensitive material (credentials, internal infrastructure,
              or security-critical details) and is restricted to superadmins.
              Your role <code>{user?.role ?? 'unknown'}</code> cannot view it.
            </p>
          </>
        ) : (
          <>
            <div className="rbac-denied-title">Access denied</div>
            <p className="rbac-denied-text">
              Your role <code>{user?.role ?? 'unknown'}</code> does not have access
              to this section of the documentation.
            </p>
          </>
        )}
        <div className="rbac-denied-actions">
          <Link to="/" className="rbac-denied-button">
            Back to home
          </Link>
          <button onClick={logout} className="rbac-denied-button rbac-denied-button-ghost">
            Sign out
          </button>
        </div>
      </div>
    </div>
  );
}
