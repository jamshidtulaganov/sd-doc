// Hardcoded user database for the client-side UX gate.
//
// ╔══════════════════════════════════════════════════════════════════════╗
// ║ THIS IS NOT SECURITY. THIS IS A VISUAL HINT.                         ║
// ║                                                                      ║
// ║ This file is bundled into every visitor's browser. Credentials and   ║
// ║ the full doc content ship in /assets/js/*.js, regardless of whether  ║
// ║ a user "logs in". A determined visitor can read any restricted page  ║
// ║ by inspecting the bundle.                                            ║
// ║                                                                      ║
// ║ For real protection, the deployment MUST sit behind a server-side    ║
// ║ gate (nginx basic-auth, Cloudflare Access, VPN, etc).                ║
// ║ See: deploy/README.md and SECURITY.md.                               ║
// ╚══════════════════════════════════════════════════════════════════════╝

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
