# Krishna Janmashtami Cultural Contest 2026 — Real Backend Setup

This package upgrades the prototype toward a real shared database and secure admin workflow using Supabase.

## Important
The included SQL creates the database schema and Row Level Security policies. The website should use a Supabase project URL and anon key in the frontend, while privileged admin actions must use a server-side Edge Function/service role.

The manual UPI payment flow remains:
1. Participant submits registration.
2. Registration is stored in the database as PENDING.
3. Participant pays ₹40 to 9437460784@ybl.
4. Authorized admin verifies the payment.
5. Registration becomes PAID or REJECTED.

Do NOT put a Supabase service-role key in the browser.

## Setup
1. Create a Supabase project.
2. Open SQL Editor.
3. Paste `supabase_schema.sql` and run it.
4. Enable Email/Password authentication in Supabase Auth.
5. Create an admin user in Auth.
6. Set that user's profile role to `admin` using the SQL shown at the bottom of the schema.
7. Put the project URL and anon key into the website's config.
8. Deploy the frontend to Vercel/Netlify/GitHub Pages.

This package is intentionally not connected to a real Supabase project because no project credentials have been supplied. Never share secret keys in chat.
