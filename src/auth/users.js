// Hardcoded user database for the client-side RBAC layer.
//
// SECURITY NOTE: This file ships in the browser bundle, so anyone who
// downloads the site can read these credentials in the source. This is a
// UX gate, not a security boundary. For real protection, put the deployed
// site behind Cloudflare Access, nginx basic-auth, or a similar server-side
// gate.
//
// To add or change users, edit this list and rebuild.

const USERS = [
  { username: 'admin',     password: 'admin',     role: 'superadmin' },
  { username: 'billing',   password: 'billing',   role: 'sd-billing' },
  { username: 'cs',        password: 'cs',        role: 'sd-cs' },
  { username: 'main',      password: 'main',      role: 'sd-main' },
  { username: 'mobile',    password: 'mobile',    role: 'sd-mobile' },
];

function findUser(username, password) {
  return USERS.find(
    (u) => u.username === username && u.password === password,
  );
}

module.exports = { USERS, findUser };
