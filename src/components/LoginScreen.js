import React, { useState } from 'react';
import { useAuth } from '@site/src/auth/AuthContext';

export default function LoginScreen() {
  const { login } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);

  const onSubmit = (e) => {
    e.preventDefault();
    setError(null);
    const result = login(username, password);
    if (!result.ok) setError(result.error);
  };

  return (
    <div className="rbac-login-shell">
      <form className="rbac-login-card" onSubmit={onSubmit}>
        <div className="rbac-login-title">SalesDoctor Docs</div>
        <div className="rbac-login-sub">Sign in to view the documentation</div>

        <label className="rbac-login-label">
          Username
          <input
            type="text"
            autoFocus
            autoComplete="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            className="rbac-login-input"
          />
        </label>

        <label className="rbac-login-label">
          Password
          <input
            type="password"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="rbac-login-input"
          />
        </label>

        {error && <div className="rbac-login-error">{error}</div>}

        <button type="submit" className="rbac-login-button">
          Sign in
        </button>

        <div className="rbac-login-hint">
          Roles: <code>superadmin</code>, <code>sd-billing</code>,{' '}
          <code>sd-cs</code>, <code>sd-main</code>, <code>sd-mobile</code>
        </div>
      </form>
    </div>
  );
}
