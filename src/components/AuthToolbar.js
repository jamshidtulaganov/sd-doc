import React, { useState } from 'react';
import { useAuth } from '@site/src/auth/AuthContext';

export default function AuthToolbar() {
  const { user, role, editMode, isSuperadmin, toggleEditMode, logout } = useAuth();
  const [open, setOpen] = useState(false);

  if (!user) return null;

  return (
    <div className={`rbac-toolbar ${editMode ? 'rbac-toolbar--editing' : ''}`}>
      <button
        className="rbac-toolbar-trigger"
        onClick={() => setOpen((v) => !v)}
        aria-expanded={open}
        title="Account"
      >
        <span className="rbac-toolbar-avatar">{user.username.charAt(0).toUpperCase()}</span>
        <span className="rbac-toolbar-name">{user.username}</span>
        <span className="rbac-toolbar-role">{role}</span>
      </button>

      {open && (
        <div className="rbac-toolbar-menu" role="menu">
          <div className="rbac-toolbar-menu-header">
            Signed in as <strong>{user.username}</strong>
            <div className="rbac-toolbar-menu-role">role: {role}</div>
          </div>

          {isSuperadmin && (
            <button
              className={`rbac-toolbar-menu-item ${editMode ? 'is-active' : ''}`}
              onClick={() => {
                toggleEditMode();
                setOpen(false);
              }}
              role="menuitemcheckbox"
              aria-checked={editMode}
            >
              <span>Edit mode</span>
              <span className="rbac-toolbar-menu-toggle">{editMode ? 'ON' : 'OFF'}</span>
            </button>
          )}

          <button
            className="rbac-toolbar-menu-item"
            onClick={() => {
              logout();
              setOpen(false);
            }}
            role="menuitem"
          >
            Sign out
          </button>
        </div>
      )}

      {editMode && <div className="rbac-edit-banner">EDIT MODE — superadmin</div>}
    </div>
  );
}
