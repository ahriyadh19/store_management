create extension if not exists pgcrypto;

create or replace function public.now_millis()
returns bigint
language sql
as $$
  select (extract(epoch from now()) * 1000)::bigint;
$$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new."updatedAt" = public.now_millis();
  return new;
end;
$$;

create or replace function public.generate_profile_username(user_email text)
returns text
language plpgsql
as $$
declare
  base_name text;
begin
  base_name := split_part(coalesce(user_email, ''), '@', 1);

  if base_name = '' then
    base_name := 'user';
  end if;

  return lower(regexp_replace(base_name, '[^a-zA-Z0-9_]', '', 'g')) || '_' || substr(gen_random_uuid()::text, 1, 8);
end;
$$;

create table if not exists public.users (
    id bigint generated always as identity primary key,
    auth_user_id uuid unique references auth.users (id) on delete cascade,
    uuid uuid not null default gen_random_uuid () unique,
    name text not null default '',
    email text not null unique,
    username text not null unique,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis ()
);

comment on
table public.users is 'Application user profiles linked to Supabase auth.users. Passwords stay in Supabase Auth and are not stored here.';

comment on column public.users.auth_user_id is 'Reference to auth.users.id for authenticated users.';

create table if not exists public.company (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis ()
);

create table if not exists public.products (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis ()
);

create table if not exists public.categories (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "parentId" bigint references public.categories (id) on delete set null,
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis (),
    constraint categories_parent_not_self check (
        "parentId" is null
        or "parentId" <> id
    )
);

create table if not exists public.tags (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis ()
);

create table if not exists public.roles (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis ()
);

create table if not exists public.company_products (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    "companyId" uuid not null references public.company (uuid) on delete cascade,
    "productId" uuid not null references public.products (uuid) on delete cascade,
    price numeric(12, 2) not null check (price >= 0),
    description text not null default '',
    stock integer not null default 0 check (stock >= 0),
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis (),
    constraint company_products_company_product_unique unique ("companyId", "productId")
);

create table if not exists public.products_tags (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    "productId" uuid not null references public.products (uuid) on delete cascade,
    "tagId" uuid not null references public.tags (uuid) on delete cascade,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis (),
    constraint products_tags_product_tag_unique unique ("productId", "tagId")
);

create table if not exists public.user_roles (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid () unique,
    "userId" uuid not null references public.users (uuid) on delete cascade,
    "roleId" uuid not null references public.roles (uuid) on delete cascade,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis (),
    "updatedAt" bigint not null default public.now_millis (),
    constraint user_roles_user_role_unique unique ("userId", "roleId")
);

create index if not exists idx_users_auth_user_id on public.users (auth_user_id);

create index if not exists idx_users_email on public.users (email);

create index if not exists idx_company_status on public.company (status);

create index if not exists idx_products_status on public.products (status);

create index if not exists idx_categories_parent_id on public.categories ("parentId");

create index if not exists idx_tags_status on public.tags (status);

create index if not exists idx_roles_status on public.roles (status);

create index if not exists idx_company_products_company_id on public.company_products ("companyId");

create index if not exists idx_company_products_product_id on public.company_products ("productId");

create index if not exists idx_products_tags_product_id on public.products_tags ("productId");

create index if not exists idx_products_tags_tag_id on public.products_tags ("tagId");

create index if not exists idx_user_roles_user_id on public.user_roles ("userId");

create index if not exists idx_user_roles_role_id on public.user_roles ("roleId");

drop trigger if exists set_users_updated_at on public.users;

create trigger set_users_updated_at
before update on public.users
for each row
execute function public.set_updated_at();

drop trigger if exists set_company_updated_at on public.company;

create trigger set_company_updated_at
before update on public.company
for each row
execute function public.set_updated_at();

drop trigger if exists set_products_updated_at on public.products;

create trigger set_products_updated_at
before update on public.products
for each row
execute function public.set_updated_at();

drop trigger if exists set_categories_updated_at on public.categories;

create trigger set_categories_updated_at
before update on public.categories
for each row
execute function public.set_updated_at();

drop trigger if exists set_tags_updated_at on public.tags;

create trigger set_tags_updated_at
before update on public.tags
for each row
execute function public.set_updated_at();

drop trigger if exists set_roles_updated_at on public.roles;

create trigger set_roles_updated_at
before update on public.roles
for each row
execute function public.set_updated_at();

drop trigger if exists set_company_products_updated_at on public.company_products;

create trigger set_company_products_updated_at
before update on public.company_products
for each row
execute function public.set_updated_at();

drop trigger if exists set_products_tags_updated_at on public.products_tags;

create trigger set_products_tags_updated_at
before update on public.products_tags
for each row
execute function public.set_updated_at();

drop trigger if exists set_user_roles_updated_at on public.user_roles;

create trigger set_user_roles_updated_at
before update on public.user_roles
for each row
execute function public.set_updated_at();

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (auth_user_id, email, username, name)
  values (
    new.id,
    coalesce(new.email, ''),
    public.generate_profile_username(new.email),
    coalesce(new.raw_user_meta_data ->> 'name', '')
  )
  on conflict (auth_user_id) do update
  set email = excluded.email,
      "updatedAt" = public.now_millis();

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_auth_user();

alter table public.users enable row level security;

alter table public.company enable row level security;

alter table public.products enable row level security;

alter table public.categories enable row level security;

alter table public.tags enable row level security;

alter table public.roles enable row level security;

alter table public.company_products enable row level security;

alter table public.products_tags enable row level security;

alter table public.user_roles enable row level security;

drop policy if exists users_select_own_profile on public.users;

create policy users_select_own_profile on public.users for
select to authenticated using (auth.uid () = auth_user_id);

drop policy if exists users_insert_own_profile on public.users;

create policy users_insert_own_profile on public.users for
insert
    to authenticated
with
    check (auth.uid () = auth_user_id);

drop policy if exists users_update_own_profile on public.users;

create policy users_update_own_profile on public.users for
update to authenticated using (auth.uid () = auth_user_id)
with
    check (auth.uid () = auth_user_id);

drop policy if exists company_authenticated_all on public.company;

create policy company_authenticated_all on public.company for all to authenticated using (true)
with
    check (true);

drop policy if exists products_authenticated_all on public.products;

create policy products_authenticated_all on public.products for all to authenticated using (true)
with
    check (true);

drop policy if exists categories_authenticated_all on public.categories;

create policy categories_authenticated_all on public.categories for all to authenticated using (true)
with
    check (true);

drop policy if exists tags_authenticated_all on public.tags;

create policy tags_authenticated_all on public.tags for all to authenticated using (true)
with
    check (true);

drop policy if exists roles_authenticated_all on public.roles;

create policy roles_authenticated_all on public.roles for all to authenticated using (true)
with
    check (true);

drop policy if exists company_products_authenticated_all on public.company_products;

create policy company_products_authenticated_all on public.company_products for all to authenticated using (true)
with
    check (true);

drop policy if exists products_tags_authenticated_all on public.products_tags;

create policy products_tags_authenticated_all on public.products_tags for all to authenticated using (true)
with
    check (true);

drop policy if exists user_roles_authenticated_all on public.user_roles;

create policy user_roles_authenticated_all on public.user_roles for all to authenticated using (true)
with
    check (true);