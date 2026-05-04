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
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

comment on table public.users is 'Application user profiles linked to Supabase auth.users. Passwords stay in Supabase Auth and are not stored here.';
comment on column public.users.auth_user_id is 'Reference to auth.users.id for authenticated users.';

create table if not exists public.supplier (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  name text not null,
  description text not null default '',
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
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
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create table if not exists public.category (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  name text not null,
  description text not null default '',
  status integer not null default 1 check (status in (0, 1)),
  "parentUuid" uuid references public.category (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint category_parent_not_self check ("parentUuid" is null or "parentUuid" <> uuid)
);

create or replace view public.categories as
select * from public.category;

create table if not exists public.tags (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  name text not null,
  description text not null default '',
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
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
  "updatedAt" bigint not null default public.now_millis(),
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

create table if not exists public.branch (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  name text not null,
  description text not null default '',
  address text not null default '',
  phone text not null default '',
  email text not null default '',
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
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
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create table if not exists public.supplier_products (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "supplierUuid" uuid not null references public.supplier (uuid) on delete cascade,
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
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint supplier_products_supplier_product_unique unique ("supplierUuid", "productUuid")
);

create table if not exists public.products_tags (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "productUuid" uuid not null references public.products (uuid) on delete cascade,
  "tagUuid" uuid not null references public.tags (uuid) on delete cascade,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint products_tags_product_tag_unique unique ("productUuid", "tagUuid")
);

create table if not exists public.user_roles (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "userUuid" uuid not null references public.users (uuid) on delete cascade,
  "roleUuid" uuid not null references public.roles (uuid) on delete cascade,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint user_roles_user_role_unique unique ("userUuid", "roleUuid")
);

create table if not exists public.store_supplier (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "storeUuid" uuid not null references public.store (uuid) on delete cascade,
  "supplierUuid" uuid not null references public.supplier (uuid) on delete cascade,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_supplier_store_supplier_unique unique ("storeUuid", "supplierUuid")
);

create table if not exists public.store_client (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "storeUuid" uuid not null references public.store (uuid) on delete cascade,
  "clientUuid" uuid not null references public.client (uuid) on delete cascade,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_client_store_client_unique unique ("storeUuid", "clientUuid")
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
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_user_store_user_role_unique unique ("storeUuid", "userUuid", "userRoleUuid")
);

create table if not exists public.store_branches (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "storeUuid" uuid not null references public.store (uuid) on delete cascade,
  "branchUuid" uuid not null references public.branch (uuid) on delete cascade,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_branches_store_branch_unique unique ("storeUuid", "branchUuid")
);

create table if not exists public.branch_product (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "branchUuid" uuid not null references public.branch (uuid) on delete cascade,
  "supplierProductUuid" uuid not null references public.supplier_products (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  stock integer not null default 0 check (stock >= 0),
  "reservedQuantity" integer not null default 0 check ("reservedQuantity" >= 0),
  "reorderLevel" integer check ("reorderLevel" >= 0),
  "lastMovementAt" bigint,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint branch_product_branch_supplier_product_unique unique ("branchUuid", "supplierProductUuid"),
  constraint branch_product_reserved_lte_stock check ("reservedQuantity" <= stock)
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
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_invoice_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
  constraint store_invoice_store_invoice_number_unique unique ("storeUuid", "invoiceNumber")
);

create table if not exists public.store_payment_voucher (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "storeUuid" uuid not null references public.store (uuid) on delete cascade,
  "clientUuid" uuid not null references public.client (uuid) on delete restrict,
  "voucherNumber" text not null,
  "payeeName" text not null,
  amount numeric(12, 2) not null default 0 check (amount >= 0),
  "paymentMethod" text not null check ("paymentMethod" in ('cash', 'bank_transfer', 'card', 'cheque', 'mobile_money', 'other')),
  "referenceNumber" text not null,
  description text not null default '',
  "transactionDate" bigint not null,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_payment_voucher_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
  constraint store_payment_voucher_store_voucher_number_unique unique ("storeUuid", "voucherNumber")
);

create table if not exists public.store_return (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "storeUuid" uuid not null references public.store (uuid) on delete cascade,
  "clientUuid" uuid not null references public.client (uuid) on delete restrict,
  "returnNumber" text not null,
  "returnType" text not null check ("returnType" in ('sales_return', 'purchase_return', 'adjustment_return')),
  "itemCount" integer not null default 1 check ("itemCount" > 0),
  "totalAmount" numeric(12, 2) not null default 0 check ("totalAmount" >= 0),
  reason text not null default '',
  "transactionDate" bigint not null,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_return_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
  constraint store_return_store_return_number_unique unique ("storeUuid", "returnNumber")
);

create table if not exists public.store_financial_transaction (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "storeUuid" uuid not null references public.store (uuid) on delete cascade,
  "clientUuid" uuid not null references public.client (uuid) on delete restrict,
  "transactionNumber" text not null,
  "transactionType" text not null check ("transactionType" in ('invoice_posting', 'payment_receipt', 'return_posting', 'adjustment')),
  "sourceType" text not null check ("sourceType" in ('invoice', 'payment_voucher', 'store_return', 'inventory_movement', 'manual')),
  "sourceUuid" uuid not null,
  amount numeric(12, 2) not null default 0 check (amount >= 0),
  "entryType" text not null check ("entryType" in ('debit', 'credit')),
  description text not null default '',
  "transactionDate" bigint not null,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint store_financial_transaction_store_client_fk foreign key ("storeUuid", "clientUuid") references public.store_client ("storeUuid", "clientUuid") on delete restrict,
  constraint store_financial_transaction_store_transaction_number_unique unique ("storeUuid", "transactionNumber")
);

create table if not exists public.store_invoice_item (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "invoiceUuid" uuid not null references public.store_invoice (uuid) on delete cascade,
  "supplierProductUuid" uuid not null references public.supplier_products (uuid) on delete restrict,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  quantity integer not null check (quantity > 0),
  "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
  "discountAmount" numeric(12, 2) not null default 0 check ("discountAmount" >= 0),
  "taxAmount" numeric(12, 2) not null default 0 check ("taxAmount" >= 0),
  "lineTotal" numeric(12, 2) not null check ("lineTotal" >= 0),
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create table if not exists public.store_return_item (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "returnUuid" uuid not null references public.store_return (uuid) on delete cascade,
  "invoiceItemUuid" uuid references public.store_invoice_item (uuid) on delete set null,
  "supplierProductUuid" uuid not null references public.supplier_products (uuid) on delete restrict,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  quantity integer not null check (quantity > 0),
  "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
  "lineTotal" numeric(12, 2) not null check ("lineTotal" >= 0),
  reason text not null default '',
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create table if not exists public.inventory_movement (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "supplierProductUuid" uuid not null references public.supplier_products (uuid) on delete restrict,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  "movementType" text not null check ("movementType" in ('purchase', 'sale', 'return_in', 'return_out', 'restock', 'transfer', 'adjustment')),
  "inventoryHolderType" text check ("inventoryHolderType" in ('store', 'branch')),
  "inventoryHolderUuid" uuid,
  "quantityDelta" integer not null check ("quantityDelta" <> 0),
  "balanceAfter" integer not null check ("balanceAfter" >= 0),
  "unitCost" numeric(12, 2) check ("unitCost" >= 0),
  "referenceType" text not null check ("referenceType" in ('invoice', 'invoice_item', 'store_return', 'return_item', 'restock', 'transfer', 'adjustment')),
  "referenceUuid" uuid,
  "counterpartyHolderType" text check ("counterpartyHolderType" in ('store', 'branch')),
  "counterpartyHolderUuid" uuid,
  "transactionUuid" uuid,
  note text not null default '',
  "createdByUserUuid" uuid references public.users (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
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
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint payment_allocation_payment_invoice_unique unique ("paymentVoucherUuid", "invoiceUuid")
);

create index if not exists idx_users_auth_user_id on public.users (auth_user_id);
create index if not exists idx_users_email on public.users (email);
create index if not exists idx_supplier_status on public.supplier (status);
create index if not exists idx_products_status on public.products (status);
create index if not exists idx_category_parent_uuid on public.category ("parentUuid");
create index if not exists idx_tags_status on public.tags (status);
create index if not exists idx_roles_status on public.roles (status);
create index if not exists idx_branch_status on public.branch (status);
create index if not exists idx_client_status on public.client (status);
create index if not exists idx_supplier_products_supplier_uuid on public.supplier_products ("supplierUuid");
create index if not exists idx_supplier_products_product_uuid on public.supplier_products ("productUuid");
create index if not exists idx_products_tags_product_uuid on public.products_tags ("productUuid");
create index if not exists idx_products_tags_tag_uuid on public.products_tags ("tagUuid");
create index if not exists idx_user_roles_user_uuid on public.user_roles ("userUuid");
create index if not exists idx_user_roles_role_uuid on public.user_roles ("roleUuid");
create index if not exists idx_store_supplier_store_uuid on public.store_supplier ("storeUuid");
create index if not exists idx_store_supplier_supplier_uuid on public.store_supplier ("supplierUuid");
create index if not exists idx_store_client_store_uuid on public.store_client ("storeUuid");
create index if not exists idx_store_client_client_uuid on public.store_client ("clientUuid");
create index if not exists idx_store_user_store_uuid on public.store_user ("storeUuid");
create index if not exists idx_store_user_user_uuid on public.store_user ("userUuid");
create index if not exists idx_store_user_user_role_uuid on public.store_user ("userRoleUuid");
create index if not exists idx_store_branches_store_uuid on public.store_branches ("storeUuid");
create index if not exists idx_store_branches_branch_uuid on public.store_branches ("branchUuid");
create index if not exists idx_branch_product_branch_uuid on public.branch_product ("branchUuid");
create index if not exists idx_branch_product_supplier_product_uuid on public.branch_product ("supplierProductUuid");
create index if not exists idx_branch_product_product_uuid on public.branch_product ("productUuid");
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
create index if not exists idx_store_invoice_item_supplier_product_uuid on public.store_invoice_item ("supplierProductUuid");
create index if not exists idx_store_return_item_return_uuid on public.store_return_item ("returnUuid");
create index if not exists idx_store_return_item_supplier_product_uuid on public.store_return_item ("supplierProductUuid");
create index if not exists idx_inventory_movement_supplier_product_uuid on public.inventory_movement ("supplierProductUuid");
create index if not exists idx_inventory_movement_product_uuid on public.inventory_movement ("productUuid");
create index if not exists idx_inventory_movement_holder on public.inventory_movement ("inventoryHolderType", "inventoryHolderUuid");
create index if not exists idx_inventory_movement_counterparty on public.inventory_movement ("counterpartyHolderType", "counterpartyHolderUuid");
create index if not exists idx_inventory_movement_reference on public.inventory_movement ("referenceType", "referenceUuid");
create index if not exists idx_payment_allocation_payment_voucher_uuid on public.payment_allocation ("paymentVoucherUuid");
create index if not exists idx_payment_allocation_invoice_uuid on public.payment_allocation ("invoiceUuid");

create index if not exists idx_users_active_unsynced on public.users ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_supplier_active_unsynced on public.supplier ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_products_active_unsynced on public.products ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_category_active_unsynced on public.category ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_tags_active_unsynced on public.tags ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_roles_active_unsynced on public.roles ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_branch_active_unsynced on public.branch ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_client_active_unsynced on public.client ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_supplier_products_active_unsynced on public.supplier_products ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_branch_product_active_unsynced on public.branch_product ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_store_invoice_active_unsynced on public.store_invoice ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_store_payment_voucher_active_unsynced on public.store_payment_voucher ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_store_return_active_unsynced on public.store_return ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_store_financial_transaction_active_unsynced on public.store_financial_transaction ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_store_invoice_item_active_unsynced on public.store_invoice_item ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_store_return_item_active_unsynced on public.store_return_item ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_inventory_movement_active_unsynced on public.inventory_movement ("updatedAt") where "deletedAt" is null and synced = false;
create index if not exists idx_payment_allocation_active_unsynced on public.payment_allocation ("updatedAt") where "deletedAt" is null and synced = false;

create or replace function public.ensure_updated_at_triggers()
returns void
language plpgsql
as $$
declare
  table_name text;
  target_tables text[] := array[
    'users',
    'supplier',
    'products',
    'category',
    'tags',
    'roles',
    'branch',
    'client',
    'supplier_products',
    'products_tags',
    'user_roles',
    'store_supplier',
    'store_client',
    'store_user',
    'store_branches',
    'branch_product',
    'store_invoice',
    'store_payment_voucher',
    'store_return',
    'store_financial_transaction',
    'store_invoice_item',
    'store_return_item',
    'inventory_movement',
    'payment_allocation'
  ];
begin
  foreach table_name in array target_tables loop
    execute format('drop trigger if exists set_%I_updated_at on public.%I', table_name, table_name);
    execute format(
      'create trigger set_%I_updated_at before update on public.%I for each row execute function public.set_updated_at()',
      table_name,
      table_name
    );
  end loop;
end;
$$;

select public.ensure_updated_at_triggers();
drop function if exists public.ensure_updated_at_triggers();

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

create or replace function public.enable_rls_and_authenticated_all_policies()
returns void
language plpgsql
as $$
declare
  table_name text;
  target_tables text[] := array[
    'supplier',
    'products',
    'category',
    'tags',
    'roles',
    'store',
    'branch',
    'client',
    'supplier_products',
    'products_tags',
    'user_roles',
    'store_supplier',
    'store_client',
    'store_user',
    'store_branches',
    'branch_product',
    'store_invoice',
    'store_payment_voucher',
    'store_return',
    'store_financial_transaction',
    'store_invoice_item',
    'store_return_item',
    'inventory_movement',
    'payment_allocation'
  ];
begin
  execute 'alter table public.users enable row level security';

  foreach table_name in array target_tables loop
    execute format('alter table public.%I enable row level security', table_name);
    execute format('drop policy if exists authenticated_all on public.%I', table_name);
    execute format('create policy authenticated_all on public.%I for all to authenticated using (true) with check (true)', table_name);
  end loop;

  execute 'drop policy if exists users_select_own_profile on public.users';
  execute 'create policy users_select_own_profile on public.users for select to authenticated using (auth.uid() = auth_user_id)';

  execute 'drop policy if exists users_insert_own_profile on public.users';
  execute 'create policy users_insert_own_profile on public.users for insert to authenticated with check (auth.uid() = auth_user_id)';

  execute 'drop policy if exists users_update_own_profile on public.users';
  execute 'create policy users_update_own_profile on public.users for update to authenticated using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id)';
end;
$$;

select public.enable_rls_and_authenticated_all_policies();
drop function if exists public.enable_rls_and_authenticated_all_policies();