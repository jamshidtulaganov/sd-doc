import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { findUser } from './users';
import { hasAccess, isSuperadmin } from './permissions';

const STORAGE_KEY = 'sd-docs.auth.v1';

const AuthContext = createContext(null);

function readStored() {
  if (typeof window === 'undefined') return null;
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

function writeStored(state) {
  if (typeof window === 'undefined') return;
  try {
    if (state) {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } else {
      window.localStorage.removeItem(STORAGE_KEY);
    }
  } catch {
    // ignore quota / disabled storage
  }
}

export function AuthProvider({ children }) {
  // SSR renders as logged-out, then hydrates from localStorage on the client.
  // `hydrated` prevents flashing the login screen during SSR output.
  const [user, setUser] = useState(null);
  const [editMode, setEditMode] = useState(false);
  const [hydrated, setHydrated] = useState(false);

  useEffect(() => {
    const stored = readStored();
    if (stored && stored.user) {
      setUser(stored.user);
      setEditMode(Boolean(stored.editMode));
    }
    setHydrated(true);
  }, []);

  useEffect(() => {
    if (!hydrated) return;
    writeStored(user ? { user, editMode } : null);
  }, [user, editMode, hydrated]);

  useEffect(() => {
    if (typeof document === 'undefined') return;
    const cls = 'rbac-edit-mode';
    if (editMode && user && isSuperadmin(user.role)) {
      document.body.classList.add(cls);
    } else {
      document.body.classList.remove(cls);
    }
  }, [editMode, user]);

  const login = useCallback((username, password) => {
    const match = findUser(username.trim(), password);
    if (!match) {
      return { ok: false, error: 'Invalid username or password.' };
    }
    setUser({ username: match.username, role: match.role });
    return { ok: true };
  }, []);

  const logout = useCallback(() => {
    setUser(null);
    setEditMode(false);
  }, []);

  const toggleEditMode = useCallback(() => {
    setEditMode((v) => !v);
  }, []);

  const value = useMemo(
    () => ({
      user,
      role: user?.role ?? null,
      hydrated,
      editMode: editMode && !!user && isSuperadmin(user.role),
      isSuperadmin: !!user && isSuperadmin(user.role),
      login,
      logout,
      toggleEditMode,
      canView: (path) => (user ? hasAccess(user.role, path) : false),
    }),
    [user, hydrated, editMode, login, logout, toggleEditMode],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    // Outside provider (e.g. SSR before Root mounts): return a safe stub.
    return {
      user: null,
      role: null,
      hydrated: false,
      editMode: false,
      isSuperadmin: false,
      login: () => ({ ok: false, error: 'Auth not ready' }),
      logout: () => {},
      toggleEditMode: () => {},
      canView: () => false,
    };
  }
  return ctx;
}
