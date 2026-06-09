// ── Current-branch service ────────────────────────────────────────────────────
//
// SINGLE SOURCE OF TRUTH for the active branch ID.
// Hard-coded to GemWorkers Netherlands during single-user dev phase.
//
// TODO: Replace kCurrentBranchId with a lookup against users.branch_id once
//       per-user auth is wired up. Users table will have:
//         users.branch_id FK → branches(id)
//       Swap the constant below with: Supabase.instance.client.auth.currentUser
//       and a DB query for that user's branch.

/// UUID of the branch that owns all new inventory items, orders, and purchases.
const String kCurrentBranchId = 'a0000000-0000-0000-0000-000000000001';
