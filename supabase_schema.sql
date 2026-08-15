create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'admin' check (role in ('admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.registrations (
  id uuid primary key default gen_random_uuid(),
  registration_id text unique not null,
  participant_name text not null,
  class_name text not null,
  institution text not null,
  contact_number text not null,
  event_name text not null check (event_name in (
    'Krishna Vesa Competition',
    'Bhagavad Gita Shloka Recitation',
    'Krishna Song / Bhajan Singing',
    'Dance Event on Krishna''s Song',
    'Krishna Drawing Competition'
  )),
  amount integer not null default 40 check (amount = 40),
  payment_status text not null default 'PENDING' check (payment_status in ('PENDING','PAID','REJECTED')),
  created_at timestamptz not null default now(),
  verified_at timestamptz,
  verified_by uuid references auth.users(id)
);

create index if not exists registrations_created_at_idx on public.registrations(created_at desc);
create index if not exists registrations_payment_status_idx on public.registrations(payment_status);
create index if not exists registrations_event_idx on public.registrations(event_name);

alter table public.profiles enable row level security;
alter table public.registrations enable row level security;

-- Admins can read/update registrations.
create policy "admins can read registrations"
on public.registrations for select
to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

create policy "admins can update registrations"
on public.registrations for update
to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

create policy "admins can read profiles"
on public.profiles for select
to authenticated
using (id = auth.uid() and role = 'admin');

-- Public registration insertion is intentionally limited to the exact columns needed.
-- For production, prefer a Supabase Edge Function with server-side validation/rate limiting.
create policy "public can create registrations"
on public.registrations for insert
to anon, authenticated
with check (
  amount = 40
  and payment_status = 'PENDING'
  and length(participant_name) between 1 and 100
  and length(class_name) between 1 and 50
  and length(institution) between 1 and 150
  and contact_number ~ '^[0-9]{10}$'
);

-- Helper function for an admin to mark a payment.
create or replace function public.verify_registration(
  p_registration_id text,
  p_status text
)
returns void
language plpgsql
security invoker
as $$
begin
  if p_status not in ('PAID','REJECTED') then
    raise exception 'Invalid status';
  end if;

  update public.registrations
  set payment_status = p_status,
      verified_at = now(),
      verified_by = auth.uid()
  where registration_id = p_registration_id
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin');

  if not found then
    raise exception 'Not authorized or registration not found';
  end if;
end;
$$;

-- After creating your admin Auth user, run:
-- insert into public.profiles (id, role) values ('AUTH_USER_UUID_HERE', 'admin');
