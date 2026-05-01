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
    uuid uuid not null default gen_random_uuid() unique,
    name text not null default '',
    email text not null unique,
    username text not null unique,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

comment on table public.users is 'Application user profiles linked to Supabase auth.users. Passwords stay in Supabase Auth and are not stored here.';
comment on column public.users.auth_user_id is 'Reference to auth.users.id for authenticated users.';

create table if not exists public.company (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.products (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.categories (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "parentUuid" uuid references public.categories (uuid) on delete set null,
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint categories_parent_not_self check (
    "parentUuid" is null
    or "parentUuid" <> uuid
),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.tags (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.roles (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    address text not null default '',
    phone text not null default '',
email text not null default '',
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.client (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    name text not null,
    description text not null default '',
    email text not null default '',
    phone text not null default '',
    address text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "creditLimit" numeric(12, 2) not null default 0 check ("creditLimit" >= 0),
    "currentCredit" numeric(12, 2) not null default 0 check ("currentCredit" >= 0),
    "availableCredit" numeric(12, 2) not null default 0 check ("availableCredit" >= 0),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.company_products (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "companyUuid" uuid not null references public.company (uuid) on delete cascade,
    "productUuid" uuid not null references public.products (uuid) on delete cascade,
    price numeric(12, 2) not null check (price >= 0),
    "costPrice" numeric(12, 2) check ("costPrice" >= 0),
    sku text,
    barcode text,
    "reorderLevel" integer check ("reorderLevel" >= 0),
    "reorderQuantity" integer check ("reorderQuantity" >= 0),
    description text not null default '',
    stock integer not null default 0 check (stock >= 0),
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint company_products_company_product_unique unique ("companyUuid", "productUuid"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.products_tags (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "productUuid" uuid not null references public.products (uuid) on delete cascade,
    "tagUuid" uuid not null references public.tags (uuid) on delete cascade,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint products_tags_product_tag_unique unique ("productUuid", "tagUuid"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.user_roles (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "userUuid" uuid not null references public.users (uuid) on delete cascade,
    "roleUuid" uuid not null references public.roles (uuid) on delete cascade,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint user_roles_user_role_unique unique ("userUuid", "roleUuid"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_company (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "companyUuid" uuid not null references public.company (uuid) on delete cascade,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint store_company_store_company_unique unique ("storeUuid", "companyUuid"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_client (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "clientUuid" uuid not null references public.client (uuid) on delete cascade,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint store_client_store_client_unique unique ("storeUuid", "clientUuid"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_user (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "userUuid" uuid not null references public.users (uuid) on delete cascade,
    "userRoleUuid" uuid not null references public.user_roles (uuid) on delete restrict,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint store_user_store_user_role_unique unique (
    "storeUuid",
    "userUuid",
    "userRoleUuid"
),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_invoice (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "clientUuid" uuid not null references public.client (uuid) on delete restrict,
    "invoiceNumber" text not null,
    "invoiceType" text not null default 'cash' check ("invoiceType" in ('cash', 'credit')),
    "itemCount" integer not null default 0 check ("itemCount" >= 0),
    "totalAmount" numeric(12, 2) not null default 0 check ("totalAmount" >= 0),
    "paidAmount" numeric(12, 2) not null default 0 check ("paidAmount" >= 0),
    "balanceAmount" numeric(12, 2) not null default 0 check ("balanceAmount" >= 0),
    notes text not null default '',
    "issuedAt" bigint not null,
    "dueAt" bigint not null,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint store_invoice_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
constraint store_invoice_store_invoice_number_unique unique ("storeUuid", "invoiceNumber"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_payment_voucher (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "clientUuid" uuid not null references public.client (uuid) on delete restrict,
    "voucherNumber" text not null,
    "payeeName" text not null,
    amount numeric(12, 2) not null default 0 check (amount >= 0),
    "paymentMethod" text not null,
    "referenceNumber" text not null,
    description text not null default '',
    "transactionDate" bigint not null,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint store_payment_voucher_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
constraint store_payment_voucher_store_voucher_number_unique unique ("storeUuid", "voucherNumber"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_return (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "clientUuid" uuid not null references public.client (uuid) on delete restrict,
    "returnNumber" text not null,
    "returnType" text not null,
    "itemCount" integer not null default 1 check ("itemCount" > 0),
    "totalAmount" numeric(12, 2) not null default 0 check ("totalAmount" >= 0),
    reason text not null default '',
    "transactionDate" bigint not null,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint store_return_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
constraint store_return_store_return_number_unique unique ("storeUuid", "returnNumber"),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_financial_transaction (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "storeUuid" uuid not null references public.store (uuid) on delete cascade,
    "clientUuid" uuid not null references public.client (uuid) on delete restrict,
    "transactionNumber" text not null,
    "transactionType" text not null,
    "sourceType" text not null,
    "sourceUuid" uuid not null,
    amount numeric(12, 2) not null default 0 check (amount >= 0),
    "entryType" text not null,
    description text not null default '',
    "transactionDate" bigint not null,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint store_financial_transaction_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
constraint store_financial_transaction_store_transaction_number_unique unique (
    "storeUuid",
    "transactionNumber"
),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_invoice_item (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "invoiceUuid" uuid not null references public.store_invoice (uuid) on delete cascade,
    "companyProductUuid" uuid not null references public.company_products (uuid) on delete restrict,
    "productUuid" uuid not null references public.products (uuid) on delete restrict,
    quantity integer not null check (quantity > 0),
    "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
    "discountAmount" numeric(12, 2) not null default 0 check ("discountAmount" >= 0),
    "taxAmount" numeric(12, 2) not null default 0 check ("taxAmount" >= 0),
    "lineTotal" numeric(12, 2) not null check ("lineTotal" >= 0),
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.store_return_item (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "returnUuid" uuid not null references public.store_return (uuid) on delete cascade,
    "invoiceItemUuid" uuid references public.store_invoice_item (uuid) on delete set null,
    "companyProductUuid" uuid not null references public.company_products (uuid) on delete restrict,
    "productUuid" uuid not null references public.products (uuid) on delete restrict,
    quantity integer not null check (quantity > 0),
    "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
    "lineTotal" numeric(12, 2) not null check ("lineTotal" >= 0),
    reason text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.inventory_movement (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "companyProductUuid" uuid not null references public.company_products (uuid) on delete restrict,
    "productUuid" uuid not null references public.products (uuid) on delete restrict,
    "movementType" text not null,
    "quantityDelta" integer not null check ("quantityDelta" <> 0),
    "balanceAfter" integer not null check ("balanceAfter" >= 0),
    "unitCost" numeric(12, 2) check ("unitCost" >= 0),
    "referenceType" text not null,
    "referenceUuid" uuid,
    note text not null default '',
    "createdByUserUuid" uuid references public.users (uuid) on delete set null,
    "createdAt" bigint not null default public.now_millis(),
"updatedAt" bigint not null default public.now_millis (),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create table if not exists public.payment_allocation (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "paymentVoucherUuid" uuid not null references public.store_payment_voucher (uuid) on delete cascade,
    "invoiceUuid" uuid not null references public.store_invoice (uuid) on delete cascade,
    "allocatedAmount" numeric(12, 2) not null check ("allocatedAmount" > 0),
    "allocationDate" bigint not null,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
constraint payment_allocation_payment_invoice_unique unique (
    "paymentVoucherUuid",
    "invoiceUuid"
),
synced boolean not null default false,
"deletedAt" bigint,
"syncedAt" bigint
);

create index if not exists idx_users_auth_user_id on public.users (auth_user_id);
create index if not exists idx_users_email on public.users (email);
create index if not exists idx_company_status on public.company (status);
create index if not exists idx_products_status on public.products (status);
create index if not exists idx_categories_parent_uuid on public.categories ("parentUuid");
create index if not exists idx_tags_status on public.tags (status);
create index if not exists idx_roles_status on public.roles (status);
create index if not exists idx_client_status on public.client (status);
create index if not exists idx_company_products_company_uuid on public.company_products ("companyUuid");
create index if not exists idx_company_products_product_uuid on public.company_products ("productUuid");
create index if not exists idx_products_tags_product_uuid on public.products_tags ("productUuid");
create index if not exists idx_products_tags_tag_uuid on public.products_tags ("tagUuid");
create index if not exists idx_user_roles_user_uuid on public.user_roles ("userUuid");
create index if not exists idx_user_roles_role_uuid on public.user_roles ("roleUuid");
create index if not exists idx_store_company_store_uuid on public.store_company ("storeUuid");
create index if not exists idx_store_company_company_uuid on public.store_company ("companyUuid");
create index if not exists idx_store_client_store_uuid on public.store_client ("storeUuid");
create index if not exists idx_store_client_client_uuid on public.store_client ("clientUuid");
create index if not exists idx_store_user_store_uuid on public.store_user ("storeUuid");
create index if not exists idx_store_user_user_uuid on public.store_user ("userUuid");
create index if not exists idx_store_user_user_role_uuid on public.store_user ("userRoleUuid");
create index if not exists idx_store_invoice_store_uuid on public.store_invoice ("storeUuid");
create index if not exists idx_store_invoice_client_uuid on public.store_invoice ("clientUuid");
create index if not exists idx_store_invoice_due_at on public.store_invoice ("dueAt");
create index if not exists idx_store_payment_voucher_store_uuid on public.store_payment_voucher ("storeUuid");
create index if not exists idx_store_payment_voucher_client_uuid on public.store_payment_voucher ("clientUuid");
create index if not exists idx_store_payment_voucher_transaction_date on public.store_payment_voucher ("transactionDate");
create index if not exists idx_store_return_store_uuid on public.store_return ("storeUuid");
create index if not exists idx_store_return_client_uuid on public.store_return ("clientUuid");
create index if not exists idx_store_return_transaction_date on public.store_return ("transactionDate");
create index if not exists idx_store_financial_transaction_store_uuid on public.store_financial_transaction ("storeUuid");
create index if not exists idx_store_financial_transaction_client_uuid on public.store_financial_transaction ("clientUuid");
create index if not exists idx_store_financial_transaction_source on public.store_financial_transaction ("sourceType", "sourceUuid");
create index if not exists idx_store_invoice_item_invoice_uuid on public.store_invoice_item ("invoiceUuid");
create index if not exists idx_store_invoice_item_company_product_uuid on public.store_invoice_item ("companyProductUuid");
create index if not exists idx_store_return_item_return_uuid on public.store_return_item ("returnUuid");
create index if not exists idx_store_return_item_company_product_uuid on public.store_return_item ("companyProductUuid");
create index if not exists idx_inventory_movement_company_product_uuid on public.inventory_movement ("companyProductUuid");
create index if not exists idx_inventory_movement_reference on public.inventory_movement ("referenceType", "referenceUuid");
create index if not exists idx_payment_allocation_payment_voucher_uuid on public.payment_allocation ("paymentVoucherUuid");
create index if not exists idx_payment_allocation_invoice_uuid on public.payment_allocation ("invoiceUuid");

drop trigger if exists set_users_updated_at on public.users;
create trigger set_users_updated_at before update on public.users for each row execute function public.set_updated_at();

drop trigger if exists set_company_updated_at on public.company;
create trigger set_company_updated_at before update on public.company for each row execute function public.set_updated_at();

drop trigger if exists set_products_updated_at on public.products;
create trigger set_products_updated_at before update on public.products for each row execute function public.set_updated_at();

drop trigger if exists set_categories_updated_at on public.categories;
create trigger set_categories_updated_at before update on public.categories for each row execute function public.set_updated_at();

drop trigger if exists set_tags_updated_at on public.tags;
create trigger set_tags_updated_at before update on public.tags for each row execute function public.set_updated_at();

drop trigger if exists set_roles_updated_at on public.roles;
create trigger set_roles_updated_at before update on public.roles for each row execute function public.set_updated_at();

drop trigger if exists set_client_updated_at on public.client;
create trigger set_client_updated_at before update on public.client for each row execute function public.set_updated_at();

drop trigger if exists set_company_products_updated_at on public.company_products;
create trigger set_company_products_updated_at before update on public.company_products for each row execute function public.set_updated_at();

drop trigger if exists set_products_tags_updated_at on public.products_tags;
create trigger set_products_tags_updated_at before update on public.products_tags for each row execute function public.set_updated_at();

drop trigger if exists set_user_roles_updated_at on public.user_roles;
create trigger set_user_roles_updated_at before update on public.user_roles for each row execute function public.set_updated_at();

drop trigger if exists set_store_company_updated_at on public.store_company;
create trigger set_store_company_updated_at before update on public.store_company for each row execute function public.set_updated_at();

drop trigger if exists set_store_client_updated_at on public.store_client;
create trigger set_store_client_updated_at before update on public.store_client for each row execute function public.set_updated_at();

drop trigger if exists set_store_user_updated_at on public.store_user;
create trigger set_store_user_updated_at before update on public.store_user for each row execute function public.set_updated_at();

drop trigger if exists set_store_invoice_updated_at on public.store_invoice;
create trigger set_store_invoice_updated_at before update on public.store_invoice for each row execute function public.set_updated_at();

drop trigger if exists set_store_payment_voucher_updated_at on public.store_payment_voucher;
create trigger set_store_payment_voucher_updated_at before update on public.store_payment_voucher for each row execute function public.set_updated_at();

drop trigger if exists set_store_return_updated_at on public.store_return;
create trigger set_store_return_updated_at before update on public.store_return for each row execute function public.set_updated_at();

drop trigger if exists set_store_financial_transaction_updated_at on public.store_financial_transaction;
create trigger set_store_financial_transaction_updated_at before update on public.store_financial_transaction for each row execute function public.set_updated_at();

drop trigger if exists set_store_invoice_item_updated_at on public.store_invoice_item;
create trigger set_store_invoice_item_updated_at before update on public.store_invoice_item for each row execute function public.set_updated_at();

drop trigger if exists set_store_return_item_updated_at on public.store_return_item;
create trigger set_store_return_item_updated_at before update on public.store_return_item for each row execute function public.set_updated_at();

drop trigger if exists set_inventory_movement_updated_at on public.inventory_movement;
create trigger set_inventory_movement_updated_at before update on public.inventory_movement for each row execute function public.set_updated_at();

drop trigger if exists set_payment_allocation_updated_at on public.payment_allocation;
create trigger set_payment_allocation_updated_at before update on public.payment_allocation for each row execute function public.set_updated_at();

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  requested_username text;
begin
  requested_username := lower(
    regexp_replace(
      coalesce(new.raw_user_meta_data ->> 'username', ''),
      '[^a-zA-Z0-9_]',
      '',
      'g'
    )
  );

  insert into public.users (auth_user_id, email, username, name)
  values (
    new.id,
    coalesce(new.email, ''),
    case
      when requested_username = '' then public.generate_profile_username(new.email)
      else requested_username
    end,
    coalesce(new.raw_user_meta_data ->> 'name', '')
  )
  on conflict (auth_user_id) do update
  set email = excluded.email,
      name = excluded.name,
      username = excluded.username,
      "updatedAt" = public.now_millis();

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_auth_user();

alter table public.users enable row level security;
alter table public.company enable row level security;
alter table public.products enable row level security;
alter table public.categories enable row level security;
alter table public.tags enable row level security;
alter table public.roles enable row level security;
alter table public.store enable row level security;
alter table public.client enable row level security;
alter table public.company_products enable row level security;
alter table public.products_tags enable row level security;
alter table public.user_roles enable row level security;
alter table public.store_company enable row level security;
alter table public.store_client enable row level security;
alter table public.store_user enable row level security;
alter table public.store_invoice enable row level security;
alter table public.store_payment_voucher enable row level security;
alter table public.store_return enable row level security;
alter table public.store_financial_transaction enable row level security;
alter table public.store_invoice_item enable row level security;
alter table public.store_return_item enable row level security;
alter table public.inventory_movement enable row level security;
alter table public.payment_allocation enable row level security;

drop policy if exists users_select_own_profile on public.users;
create policy users_select_own_profile on public.users for select to authenticated using (auth.uid() = auth_user_id);

drop policy if exists users_insert_own_profile on public.users;
create policy users_insert_own_profile on public.users for insert to authenticated with check (auth.uid() = auth_user_id);

drop policy if exists users_update_own_profile on public.users;
create policy users_update_own_profile on public.users for update to authenticated using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);

drop policy if exists company_authenticated_all on public.company;
create policy company_authenticated_all on public.company for all to authenticated using (true) with check (true);

drop policy if exists products_authenticated_all on public.products;
create policy products_authenticated_all on public.products for all to authenticated using (true) with check (true);

drop policy if exists categories_authenticated_all on public.categories;
create policy categories_authenticated_all on public.categories for all to authenticated using (true) with check (true);

drop policy if exists tags_authenticated_all on public.tags;
create policy tags_authenticated_all on public.tags for all to authenticated using (true) with check (true);

drop policy if exists roles_authenticated_all on public.roles;
create policy roles_authenticated_all on public.roles for all to authenticated using (true) with check (true);

drop policy if exists store_authenticated_all on public.store;
create policy store_authenticated_all on public.store for all to authenticated using (true) with check (true);

drop policy if exists client_authenticated_all on public.client;
create policy client_authenticated_all on public.client for all to authenticated using (true) with check (true);

drop policy if exists company_products_authenticated_all on public.company_products;
create policy company_products_authenticated_all on public.company_products for all to authenticated using (true) with check (true);

drop policy if exists products_tags_authenticated_all on public.products_tags;
create policy products_tags_authenticated_all on public.products_tags for all to authenticated using (true) with check (true);

drop policy if exists user_roles_authenticated_all on public.user_roles;
create policy user_roles_authenticated_all on public.user_roles for all to authenticated using (true) with check (true);

drop policy if exists store_company_authenticated_all on public.store_company;
create policy store_company_authenticated_all on public.store_company for all to authenticated using (true) with check (true);

drop policy if exists store_client_authenticated_all on public.store_client;
create policy store_client_authenticated_all on public.store_client for all to authenticated using (true) with check (true);

drop policy if exists store_user_authenticated_all on public.store_user;
create policy store_user_authenticated_all on public.store_user for all to authenticated using (true) with check (true);

drop policy if exists store_invoice_authenticated_all on public.store_invoice;
create policy store_invoice_authenticated_all on public.store_invoice for all to authenticated using (true) with check (true);

drop policy if exists store_payment_voucher_authenticated_all on public.store_payment_voucher;
create policy store_payment_voucher_authenticated_all on public.store_payment_voucher for all to authenticated using (true) with check (true);

drop policy if exists store_return_authenticated_all on public.store_return;
create policy store_return_authenticated_all on public.store_return for all to authenticated using (true) with check (true);

drop policy if exists store_financial_transaction_authenticated_all on public.store_financial_transaction;
create policy store_financial_transaction_authenticated_all on public.store_financial_transaction for all to authenticated using (true) with check (true);

drop policy if exists store_invoice_item_authenticated_all on public.store_invoice_item;
create policy store_invoice_item_authenticated_all on public.store_invoice_item for all to authenticated using (true) with check (true);

drop policy if exists store_return_item_authenticated_all on public.store_return_item;
create policy store_return_item_authenticated_all on public.store_return_item for all to authenticated using (true) with check (true);

drop policy if exists inventory_movement_authenticated_all on public.inventory_movement;
create policy inventory_movement_authenticated_all on public.inventory_movement for all to authenticated using (true) with check (true);

drop policy if exists payment_allocation_authenticated_all on public.payment_allocation;
create policy payment_allocation_authenticated_all on public.payment_allocation for all to authenticated using (true) with check (true);