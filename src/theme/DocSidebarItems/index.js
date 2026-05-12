import React from 'react';
import DocSidebarItems from '@theme-original/DocSidebarItems';
import { useAuth } from '@site/src/auth/AuthContext';
import { hasAccess } from '@site/src/auth/permissions';

function filterItem(item, role) {
  if (!item) return null;

  if (item.type === 'category') {
    const filteredChildren = (item.items || [])
      .map((child) => filterItem(child, role))
      .filter(Boolean);

    const linkHref = item.href || item.link?.path;
    const categoryAccessible = linkHref ? hasAccess(role, linkHref) : false;

    if (filteredChildren.length === 0 && !categoryAccessible) {
      return null;
    }
    return { ...item, items: filteredChildren };
  }

  if (item.type === 'link') {
    return hasAccess(role, item.href) ? item : null;
  }

  if (item.type === 'ref') {
    // refs don't carry an href here; allow them — if the referenced doc is
    // forbidden the page-level gate will still block it.
    return item;
  }

  // 'html' and unknown types pass through
  return item;
}

export default function DocSidebarItemsWrapper(props) {
  const { role, user } = useAuth();

  if (!user) return null;

  const filtered = (props.items || [])
    .map((item) => filterItem(item, role))
    .filter(Boolean);

  return <DocSidebarItems {...props} items={filtered} />;
}
