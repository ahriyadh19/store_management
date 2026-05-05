-- Consolidated migration rebuilt from prior migration chain
-- Source files are inlined below in execution order.


-- ===== BEGIN 20260429_000001_initial_schema.sql =====

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
"ownerUserUuid" uuid not null references public.users (uuid) on delete restrict,
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
"batchNumber" text, "expiryDate" bigint,
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
constraint supplier_products_supplier_product_variation_unique unique (
    "supplierUuid",
    "productUuid",
    "batchNumber",
    "expiryDate",
    sku,
    barcode
)
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
"branchUuid" uuid references public.branch (uuid) on delete set null,
  "userUuid" uuid not null references public.users (uuid) on delete cascade,
  "userRoleUuid" uuid not null references public.user_roles (uuid) on delete restrict,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
constraint store_user_store_branch_user_role_unique unique (
    "storeUuid",
    "branchUuid",
    "userUuid",
    "userRoleUuid"
)
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

-- ===== END 20260429_000001_initial_schema.sql =====


-- ===== BEGIN 20260501_000002_add_sync_metadata_columns.sql =====

-- Compatibility migration intentionally kept as a no-op.
-- Complete schema and sync metadata are consolidated in:
--   supabase/migrations/20260429_000001_initial_schema.sql

-- ===== END 20260501_000002_add_sync_metadata_columns.sql =====


-- ===== BEGIN 20260505_000003_multi_tenant_supplier_variations.sql =====

alter table if exists public.store
  add column if not exists "ownerUserUuid" uuid;

update public.store
set "ownerUserUuid" = (
  select u.uuid
  from public.users u
  order by u.id
  limit 1
)
where "ownerUserUuid" is null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'store_owner_user_fk'
      and conrelid = 'public.store'::regclass
  ) then
    alter table public.store
      add constraint store_owner_user_fk
      foreign key ("ownerUserUuid") references public.users (uuid) on delete restrict;
  end if;
end;
$$;

alter table if exists public.store_user
  add column if not exists "branchUuid" uuid references public.branch (uuid) on delete set null;

alter table if exists public.store_user
  drop constraint if exists store_user_store_user_role_unique;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'store_user_store_branch_user_role_unique'
      and conrelid = 'public.store_user'::regclass
  ) then
    alter table public.store_user
      add constraint store_user_store_branch_user_role_unique
      unique ("storeUuid", "branchUuid", "userUuid", "userRoleUuid");
  end if;
end;
$$;

alter table if exists public.supplier_products
  add column if not exists "batchNumber" text,
  add column if not exists "expiryDate" bigint;

alter table if exists public.supplier_products
  drop constraint if exists supplier_products_supplier_product_unique;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'supplier_products_supplier_product_variation_unique'
      and conrelid = 'public.supplier_products'::regclass
  ) then
    alter table public.supplier_products
      add constraint supplier_products_supplier_product_variation_unique
      unique ("supplierUuid", "productUuid", "batchNumber", "expiryDate", sku, barcode);
  end if;
end;
$$;

-- ===== END 20260505_000003_multi_tenant_supplier_variations.sql =====


-- ===== BEGIN 20260505_000004_operating_model_upgrade.sql =====

create extension if not exists pgcrypto;

create table if not exists public.owner_account (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  name text not null,
  code text,
  base_currency text not null default 'USD',
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint owner_account_code_unique unique (code)
);

create table if not exists public.owner_user_membership (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "userUuid" uuid not null references public.users (uuid) on delete cascade,
  role text not null check (role in ('owner', 'admin', 'manager', 'staff', 'viewer', 'accountant')),
  "permissionsJson" jsonb not null default '{}'::jsonb,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint owner_user_membership_unique unique ("ownerUuid", "userUuid")
);

create table if not exists public.owner_permission_scope (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerMembershipUuid" uuid not null references public.owner_user_membership (uuid) on delete cascade,
  "scopeType" text not null check ("scopeType" in ('owner', 'store', 'branch')),
  "scopeUuid" uuid,
  permission text not null,
  "allowWrite" boolean not null default false,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint owner_permission_scope_unique unique ("ownerMembershipUuid", "scopeType", "scopeUuid", permission)
);

insert into public.owner_account (name, code)
select distinct coalesce(s.name, 'Owner ' || substr(s.uuid::text, 1, 8)), substr(s.uuid::text, 1, 12)
from public.store s
left join public.owner_account o on o.code = substr(s.uuid::text, 1, 12)
where o.id is null
on conflict (code) do nothing;

alter table if exists public.store add column if not exists "ownerUuid" uuid;
alter table if exists public.products add column if not exists "ownerUuid" uuid;
alter table if exists public.supplier add column if not exists "ownerUuid" uuid;
alter table if exists public.client add column if not exists "ownerUuid" uuid;
alter table if exists public.branch add column if not exists "ownerUuid" uuid;
alter table if exists public.category add column if not exists "ownerUuid" uuid;
alter table if exists public.tags add column if not exists "ownerUuid" uuid;
alter table if exists public.roles add column if not exists "ownerUuid" uuid;
alter table if exists public.store_invoice add column if not exists "ownerUuid" uuid;
alter table if exists public.store_payment_voucher add column if not exists "ownerUuid" uuid;
alter table if exists public.store_return add column if not exists "ownerUuid" uuid;
alter table if exists public.store_financial_transaction add column if not exists "ownerUuid" uuid;
alter table if exists public.inventory_movement add column if not exists "ownerUuid" uuid;

update public.store s
set "ownerUuid" = oa.uuid
from public.owner_account oa
where s."ownerUuid" is null
  and oa.code = substr(s.uuid::text, 1, 12);

update public.products p
set "ownerUuid" = (
  select s."ownerUuid"
  from public.store s
  where s."ownerUuid" is not null
  order by s.id
  limit 1
)
where p."ownerUuid" is null;

update public.supplier sp
set "ownerUuid" = (
  select s."ownerUuid"
  from public.store s
  where s."ownerUuid" is not null
  order by s.id
  limit 1
)
where sp."ownerUuid" is null;

update public.client c
set "ownerUuid" = (
  select s."ownerUuid"
  from public.store s
  where s."ownerUuid" is not null
  order by s.id
  limit 1
)
where c."ownerUuid" is null;

update public.category c
set "ownerUuid" = (
  select s."ownerUuid"
  from public.store s
  where s."ownerUuid" is not null
  order by s.id
  limit 1
)
where c."ownerUuid" is null;

update public.tags t
set "ownerUuid" = (
  select s."ownerUuid"
  from public.store s
  where s."ownerUuid" is not null
  order by s.id
  limit 1
)
where t."ownerUuid" is null;

update public.roles r
set "ownerUuid" = (
  select s."ownerUuid"
  from public.store s
  where s."ownerUuid" is not null
  order by s.id
  limit 1
)
where r."ownerUuid" is null;

update public.branch b
set "ownerUuid" = s."ownerUuid"
from public.store_branches sb
join public.store s on s.uuid = sb."storeUuid"
where b.uuid = sb."branchUuid"
  and b."ownerUuid" is null;

update public.store_invoice si
set "ownerUuid" = s."ownerUuid"
from public.store s
where s.uuid = si."storeUuid"
  and si."ownerUuid" is null;

update public.store_payment_voucher spv
set "ownerUuid" = s."ownerUuid"
from public.store s
where s.uuid = spv."storeUuid"
  and spv."ownerUuid" is null;

update public.store_return sr
set "ownerUuid" = s."ownerUuid"
from public.store s
where s.uuid = sr."storeUuid"
  and sr."ownerUuid" is null;

update public.store_financial_transaction sft
set "ownerUuid" = s."ownerUuid"
from public.store s
where s.uuid = sft."storeUuid"
  and sft."ownerUuid" is null;

update public.inventory_movement im
set "ownerUuid" = b."ownerUuid"
from public.branch b
where im."inventoryHolderType" = 'branch'
  and im."inventoryHolderUuid" = b.uuid
  and im."ownerUuid" is null;

update public.inventory_movement im
set "ownerUuid" = s."ownerUuid"
from public.store s
where im."inventoryHolderType" = 'store'
  and im."inventoryHolderUuid" = s.uuid
  and im."ownerUuid" is null;

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'store_owner_uuid_fk' and conrelid = 'public.store'::regclass) then
    alter table public.store add constraint store_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'products_owner_uuid_fk' and conrelid = 'public.products'::regclass) then
    alter table public.products add constraint products_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'supplier_owner_uuid_fk' and conrelid = 'public.supplier'::regclass) then
    alter table public.supplier add constraint supplier_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'client_owner_uuid_fk' and conrelid = 'public.client'::regclass) then
    alter table public.client add constraint client_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'branch_owner_uuid_fk' and conrelid = 'public.branch'::regclass) then
    alter table public.branch add constraint branch_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'category_owner_uuid_fk' and conrelid = 'public.category'::regclass) then
    alter table public.category add constraint category_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'tags_owner_uuid_fk' and conrelid = 'public.tags'::regclass) then
    alter table public.tags add constraint tags_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'roles_owner_uuid_fk' and conrelid = 'public.roles'::regclass) then
    alter table public.roles add constraint roles_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'store_invoice_owner_uuid_fk' and conrelid = 'public.store_invoice'::regclass) then
    alter table public.store_invoice add constraint store_invoice_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'store_payment_voucher_owner_uuid_fk' and conrelid = 'public.store_payment_voucher'::regclass) then
    alter table public.store_payment_voucher add constraint store_payment_voucher_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'store_return_owner_uuid_fk' and conrelid = 'public.store_return'::regclass) then
    alter table public.store_return add constraint store_return_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'store_financial_transaction_owner_uuid_fk' and conrelid = 'public.store_financial_transaction'::regclass) then
    alter table public.store_financial_transaction add constraint store_financial_transaction_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;

  if not exists (select 1 from pg_constraint where conname = 'inventory_movement_owner_uuid_fk' and conrelid = 'public.inventory_movement'::regclass) then
    alter table public.inventory_movement add constraint inventory_movement_owner_uuid_fk foreign key ("ownerUuid") references public.owner_account (uuid) on delete restrict;
  end if;
end;
$$;

alter table if exists public.products add column if not exists sku text;
alter table if exists public.products add column if not exists "isBatchTracked" boolean not null default false;
alter table if exists public.products add column if not exists "requiresExpiryDate" boolean not null default false;

create unique index if not exists uq_products_owner_sku
  on public.products ("ownerUuid", sku)
  where "deletedAt" is null and sku is not null;

alter table if exists public.branch add column if not exists "storeUuid" uuid;

update public.branch b
set "storeUuid" = sb."storeUuid"
from (
  select "branchUuid", min("storeUuid") as "storeUuid"
  from public.store_branches
  group by "branchUuid"
) sb
where b.uuid = sb."branchUuid"
  and b."storeUuid" is null;

create index if not exists idx_branch_store_uuid on public.branch ("storeUuid");

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'branch_store_fk'
      and conrelid = 'public.branch'::regclass
  ) then
    alter table public.branch
      add constraint branch_store_fk
      foreign key ("storeUuid") references public.store (uuid) on delete restrict;
  end if;
end;
$$;

create unique index if not exists uq_store_branches_branch_single_store
  on public.store_branches ("branchUuid")
  where "deletedAt" is null;

create table if not exists public.supplier_product_offer (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "supplierUuid" uuid not null references public.supplier (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete cascade,
  "supplierSku" text,
  "defaultCost" numeric(12, 2) check ("defaultCost" >= 0),
  "leadTimeDays" integer check ("leadTimeDays" >= 0),
  "minimumOrderQty" integer check ("minimumOrderQty" >= 0),
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint supplier_product_offer_unique unique ("ownerUuid", "supplierUuid", "productUuid")
);

create table if not exists public.purchase_order (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "storeUuid" uuid not null references public.store (uuid) on delete restrict,
  "supplierUuid" uuid not null references public.supplier (uuid) on delete restrict,
  "poNumber" text not null,
  "orderDate" bigint not null,
  "expectedDate" bigint,
  status text not null check (status in ('draft', 'submitted', 'partial_received', 'received', 'cancelled')),
  "currencyCode" text not null default 'USD',
  "totalAmount" numeric(14, 2) not null default 0 check ("totalAmount" >= 0),
  "notes" text not null default '',
  "createdByUserUuid" uuid references public.users (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint purchase_order_unique unique ("ownerUuid", "poNumber")
);

create table if not exists public.purchase_order_item (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "purchaseOrderUuid" uuid not null references public.purchase_order (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  "supplierProductOfferUuid" uuid references public.supplier_product_offer (uuid) on delete set null,
  quantity integer not null check (quantity > 0),
  "unitCost" numeric(12, 2) not null check ("unitCost" >= 0),
  "discountAmount" numeric(12, 2) not null default 0 check ("discountAmount" >= 0),
  "lineTotal" numeric(14, 2) not null check ("lineTotal" >= 0),
  "receivedQuantity" integer not null default 0 check ("receivedQuantity" >= 0)
);

create table if not exists public.supplier_invoice (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "supplierUuid" uuid not null references public.supplier (uuid) on delete restrict,
  "storeUuid" uuid not null references public.store (uuid) on delete restrict,
  "purchaseOrderUuid" uuid references public.purchase_order (uuid) on delete set null,
  "supplierInvoiceNumber" text not null,
  "invoiceDate" bigint not null,
  "dueDate" bigint,
  "currencyCode" text not null default 'USD',
  "subtotal" numeric(14, 2) not null default 0 check ("subtotal" >= 0),
  "taxAmount" numeric(14, 2) not null default 0 check ("taxAmount" >= 0),
  "totalAmount" numeric(14, 2) not null default 0 check ("totalAmount" >= 0),
  status text not null check (status in ('draft', 'open', 'partially_paid', 'paid', 'cancelled')),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint supplier_invoice_unique unique ("ownerUuid", "supplierUuid", "supplierInvoiceNumber")
);

create table if not exists public.inventory_batch (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "storeUuid" uuid not null references public.store (uuid) on delete restrict,
  "supplierUuid" uuid references public.supplier (uuid) on delete set null,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  "supplierInvoiceUuid" uuid references public.supplier_invoice (uuid) on delete set null,
  "supplierInvoiceItemRef" text,
  "batchNumber" text,
  "receivedAt" bigint not null,
  "expiryDate" bigint,
  "unitCost" numeric(12, 2) not null check ("unitCost" >= 0),
  "initialQuantity" integer not null check ("initialQuantity" > 0),
  "remainingQuantity" integer not null check ("remainingQuantity" >= 0),
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint inventory_batch_unique unique ("ownerUuid", "productUuid", "supplierUuid", "batchNumber", "expiryDate", "unitCost")
);

create table if not exists public.inventory_transaction (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  "batchUuid" uuid references public.inventory_batch (uuid) on delete set null,
  "holderType" text not null check ("holderType" in ('store', 'branch')),
  "holderUuid" uuid not null,
  "transactionType" text not null check ("transactionType" in ('in', 'out', 'transfer_out', 'transfer_in', 'adjustment', 'sale', 'sale_return', 'purchase', 'supplier_return')),
  quantity integer not null check (quantity <> 0),
  "unitCost" numeric(12, 2) check ("unitCost" >= 0),
  "unitPrice" numeric(12, 2) check ("unitPrice" >= 0),
  "referenceType" text not null,
  "referenceUuid" uuid,
  "linkedTransactionUuid" uuid,
  "staffUserUuid" uuid references public.users (uuid) on delete set null,
  "occurredAt" bigint not null,
  note text not null default '',
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create index if not exists idx_inventory_transaction_owner_holder_product
  on public.inventory_transaction ("ownerUuid", "holderType", "holderUuid", "productUuid", "occurredAt");

create index if not exists idx_inventory_batch_owner_product_expiry
  on public.inventory_batch ("ownerUuid", "productUuid", "expiryDate");

create or replace view public.v_inventory_balance as
select
  it."ownerUuid",
  it."holderType",
  it."holderUuid",
  it."productUuid",
  it."batchUuid",
  sum(it.quantity) as quantity
from public.inventory_transaction it
where it."deletedAt" is null
group by it."ownerUuid", it."holderType", it."holderUuid", it."productUuid", it."batchUuid";

create table if not exists public.inventory_policy (
  id bigint generated always as identity primary key,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "allowNegativeStock" boolean not null default false,
  "batchSelectionStrategy" text not null default 'fifo' check ("batchSelectionStrategy" in ('fifo', 'fefo')),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  constraint inventory_policy_owner_unique unique ("ownerUuid")
);

create or replace function public.prevent_negative_inventory_transaction()
returns trigger
language plpgsql
as $$
declare
  current_qty integer;
  allow_negative boolean;
begin
  if new."deletedAt" is not null then
    return new;
  end if;

  if new.quantity >= 0 then
    return new;
  end if;

  select coalesce(sum(quantity), 0)
  into current_qty
  from public.inventory_transaction
  where "deletedAt" is null
    and "ownerUuid" = new."ownerUuid"
    and "holderType" = new."holderType"
    and "holderUuid" = new."holderUuid"
    and "productUuid" = new."productUuid"
    and ("batchUuid" is not distinct from new."batchUuid");

  select coalesce(ip."allowNegativeStock", false)
  into allow_negative
  from public.inventory_policy ip
  where ip."ownerUuid" = new."ownerUuid"
  limit 1;

  if not allow_negative and (current_qty + new.quantity) < 0 then
    raise exception 'Negative stock not allowed for owner %, holder %, product %', new."ownerUuid", new."holderUuid", new."productUuid";
  end if;

  return new;
end;
$$;

drop trigger if exists trg_prevent_negative_inventory_transaction on public.inventory_transaction;
create trigger trg_prevent_negative_inventory_transaction
before insert on public.inventory_transaction
for each row execute function public.prevent_negative_inventory_transaction();

create or replace function public.validate_batch_expiry_requirement()
returns trigger
language plpgsql
as $$
declare
  requires_expiry boolean;
begin
  select p."requiresExpiryDate"
  into requires_expiry
  from public.products p
  where p.uuid = new."productUuid";

  if coalesce(requires_expiry, false) and new."expiryDate" is null then
    raise exception 'Expiry date is required for product %', new."productUuid";
  end if;

  return new;
end;
$$;

drop trigger if exists trg_validate_batch_expiry_requirement on public.inventory_batch;
create trigger trg_validate_batch_expiry_requirement
before insert or update on public.inventory_batch
for each row execute function public.validate_batch_expiry_requirement();

create table if not exists public.transfer_order (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "sourceBranchUuid" uuid not null references public.branch (uuid) on delete restrict,
  "destinationBranchUuid" uuid not null references public.branch (uuid) on delete restrict,
  "transferNumber" text not null,
  status text not null check (status in ('draft', 'approved', 'in_transit', 'partially_received', 'received', 'cancelled')),
  "requestedAt" bigint not null,
  "shippedAt" bigint,
  "receivedAt" bigint,
  "createdByUserUuid" uuid references public.users (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint transfer_order_unique unique ("ownerUuid", "transferNumber"),
  constraint transfer_branch_not_same check ("sourceBranchUuid" <> "destinationBranchUuid")
);

create table if not exists public.transfer_order_item (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "transferOrderUuid" uuid not null references public.transfer_order (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  quantity integer not null check (quantity > 0),
  "shippedQuantity" integer not null default 0 check ("shippedQuantity" >= 0),
  "receivedQuantity" integer not null default 0 check ("receivedQuantity" >= 0)
);

create table if not exists public.sales_order (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "storeUuid" uuid not null references public.store (uuid) on delete restrict,
  "branchUuid" uuid not null references public.branch (uuid) on delete restrict,
  "customerUuid" uuid references public.client (uuid) on delete set null,
  "orderNumber" text not null,
  "orderDate" bigint not null,
  status text not null check (status in ('draft', 'confirmed', 'fulfilled', 'cancelled')),
  "pricingStrategy" text not null default 'branch' check ("pricingStrategy" in ('branch', 'store')),
  "createdByUserUuid" uuid references public.users (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint sales_order_unique unique ("ownerUuid", "orderNumber")
);

create table if not exists public.sales_order_item (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "salesOrderUuid" uuid not null references public.sales_order (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete restrict,
  quantity integer not null check (quantity > 0),
  "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
  "discountAmount" numeric(12, 2) not null default 0 check ("discountAmount" >= 0),
  "lineTotal" numeric(14, 2) not null check ("lineTotal" >= 0)
);

create table if not exists public.sales_invoice (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "storeUuid" uuid not null references public.store (uuid) on delete restrict,
  "branchUuid" uuid not null references public.branch (uuid) on delete restrict,
  "salesOrderUuid" uuid references public.sales_order (uuid) on delete set null,
  "customerUuid" uuid references public.client (uuid) on delete set null,
  "invoiceNumber" text not null,
  "issuedAt" bigint not null,
  "currencyCode" text not null default 'USD',
  "subtotal" numeric(14, 2) not null default 0,
  "discountAmount" numeric(14, 2) not null default 0,
  "taxAmount" numeric(14, 2) not null default 0,
  "totalAmount" numeric(14, 2) not null default 0,
  "paidAmount" numeric(14, 2) not null default 0,
  status text not null check (status in ('open', 'partially_paid', 'paid', 'void')),
  "createdByUserUuid" uuid references public.users (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint sales_invoice_unique unique ("ownerUuid", "invoiceNumber")
);

create table if not exists public.sales_return (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "salesInvoiceUuid" uuid not null references public.sales_invoice (uuid) on delete cascade,
  "returnNumber" text not null,
  "returnDate" bigint not null,
  reason text not null default '',
  "refundAmount" numeric(14, 2) not null default 0,
  status text not null check (status in ('draft', 'approved', 'refunded', 'cancelled')),
  "createdByUserUuid" uuid references public.users (uuid) on delete set null,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint sales_return_unique unique ("ownerUuid", "returnNumber")
);

create table if not exists public.branch_price (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "branchUuid" uuid not null references public.branch (uuid) on delete cascade,
  "productUuid" uuid not null references public.products (uuid) on delete cascade,
  "priceType" text not null default 'selling' check ("priceType" in ('selling', 'promo', 'wholesale')),
  price numeric(12, 2) not null check (price >= 0),
  "startsAt" bigint,
  "endsAt" bigint,
  "priority" integer not null default 0,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint,
  constraint branch_price_unique unique ("ownerUuid", "branchUuid", "productUuid", "priceType", "startsAt")
);

create table if not exists public.promotion_rule (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  name text not null,
  "branchUuid" uuid references public.branch (uuid) on delete set null,
  "productUuid" uuid references public.products (uuid) on delete set null,
  "discountType" text not null check ("discountType" in ('percent', 'fixed')),
  "discountValue" numeric(12, 2) not null check ("discountValue" >= 0),
  "startsAt" bigint not null,
  "endsAt" bigint,
  status integer not null default 1 check (status in (0, 1)),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create table if not exists public.staff_shift (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "branchUuid" uuid not null references public.branch (uuid) on delete cascade,
  "userUuid" uuid not null references public.users (uuid) on delete cascade,
  "shiftDate" bigint not null,
  "startAt" bigint not null,
  "endAt" bigint,
  status text not null check (status in ('scheduled', 'started', 'completed', 'missed', 'cancelled')),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis(),
  synced boolean not null default false,
  "deletedAt" bigint,
  "syncedAt" bigint
);

create table if not exists public.staff_attendance (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "staffShiftUuid" uuid not null references public.staff_shift (uuid) on delete cascade,
  "checkInAt" bigint,
  "checkOutAt" bigint,
  "minutesWorked" integer,
  status text not null check (status in ('present', 'late', 'absent', 'excused')),
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis()
);

create table if not exists public.staff_activity_log (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "branchUuid" uuid references public.branch (uuid) on delete set null,
  "userUuid" uuid references public.users (uuid) on delete set null,
  action text not null,
  "entityType" text not null,
  "entityUuid" uuid,
  "metadataJson" jsonb not null default '{}'::jsonb,
  "createdAt" bigint not null default public.now_millis()
);

create table if not exists public.audit_log (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid,
  "actorUserUuid" uuid references public.users (uuid) on delete set null,
  action text not null,
  "entityType" text not null,
  "entityUuid" uuid,
  "beforeJson" jsonb,
  "afterJson" jsonb,
  "origin" text,
  "requestId" text,
  "createdAt" bigint not null default public.now_millis()
);

create or replace function public.write_audit_log()
returns trigger
language plpgsql
as $$
declare
  owner_uuid uuid;
  actor_uuid uuid;
begin
  owner_uuid := coalesce((to_jsonb(new) ->> 'ownerUuid')::uuid, (to_jsonb(old) ->> 'ownerUuid')::uuid);
  select u.uuid into actor_uuid from public.users u where u.auth_user_id = auth.uid() limit 1;

  if tg_op = 'INSERT' then
    insert into public.audit_log ("ownerUuid", "actorUserUuid", action, "entityType", "entityUuid", "afterJson", "origin")
    values (owner_uuid, actor_uuid, tg_op, tg_table_name, (to_jsonb(new) ->> 'uuid')::uuid, to_jsonb(new), 'trigger');
    return new;
  elsif tg_op = 'UPDATE' then
    insert into public.audit_log ("ownerUuid", "actorUserUuid", action, "entityType", "entityUuid", "beforeJson", "afterJson", "origin")
    values (owner_uuid, actor_uuid, tg_op, tg_table_name, (to_jsonb(new) ->> 'uuid')::uuid, to_jsonb(old), to_jsonb(new), 'trigger');
    return new;
  else
    insert into public.audit_log ("ownerUuid", "actorUserUuid", action, "entityType", "entityUuid", "beforeJson", "origin")
    values (owner_uuid, actor_uuid, tg_op, tg_table_name, (to_jsonb(old) ->> 'uuid')::uuid, to_jsonb(old), 'trigger');
    return old;
  end if;
end;
$$;

drop trigger if exists trg_audit_inventory_transaction on public.inventory_transaction;
create trigger trg_audit_inventory_transaction
after insert or update or delete on public.inventory_transaction
for each row execute function public.write_audit_log();

drop trigger if exists trg_audit_sales_invoice on public.sales_invoice;
create trigger trg_audit_sales_invoice
after insert or update or delete on public.sales_invoice
for each row execute function public.write_audit_log();

drop trigger if exists trg_audit_purchase_order on public.purchase_order;
create trigger trg_audit_purchase_order
after insert or update or delete on public.purchase_order
for each row execute function public.write_audit_log();

create table if not exists public.sync_conflict_log (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid references public.owner_account (uuid) on delete cascade,
  "entityType" text not null,
  "entityUuid" uuid not null,
  "localVersionJson" jsonb,
  "remoteVersionJson" jsonb,
  "resolutionStrategy" text not null check ("resolutionStrategy" in ('last_write_wins', 'merge', 'event_based', 'manual')),
  "resolvedJson" jsonb,
  status text not null default 'pending' check (status in ('pending', 'resolved', 'ignored')),
  "createdAt" bigint not null default public.now_millis(),
  "resolvedAt" bigint
);

create table if not exists public.external_integration_endpoint (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  name text not null,
  "baseUrl" text not null,
  "apiKeyHint" text,
  "isEnabled" boolean not null default true,
  "createdAt" bigint not null default public.now_millis(),
  "updatedAt" bigint not null default public.now_millis()
);

create table if not exists public.notification_event (
  id bigint generated always as identity primary key,
  uuid uuid not null default gen_random_uuid() unique,
  "ownerUuid" uuid not null references public.owner_account (uuid) on delete cascade,
  "notificationType" text not null check ("notificationType" in ('low_stock', 'expiry', 'transfer', 'purchase', 'integration')),
  "relatedEntityType" text,
  "relatedEntityUuid" uuid,
  payload jsonb not null default '{}'::jsonb,
  status text not null default 'pending' check (status in ('pending', 'sent', 'failed', 'dismissed')),
  "createdAt" bigint not null default public.now_millis(),
  "sentAt" bigint
);

create or replace view public.v_low_stock_alert as
select
  b."ownerUuid",
  ib."holderUuid" as "branchUuid",
  ib."productUuid",
  sum(ib.quantity) as "availableQty"
from public.v_inventory_balance ib
join public.branch b on b.uuid = ib."holderUuid" and ib."holderType" = 'branch'
left join public.branch_product bp
  on bp."branchUuid" = ib."holderUuid"
 and bp."productUuid" = ib."productUuid"
 and bp."deletedAt" is null
where ib.quantity > 0
group by b."ownerUuid", ib."holderUuid", ib."productUuid"
having sum(ib.quantity) <= coalesce(min(bp."reorderLevel"), 0);

create or replace view public.v_expiry_tracking as
select
  ib."ownerUuid",
  ib."storeUuid",
  ib."productUuid",
  ib."batchNumber",
  ib."expiryDate",
  ib."remainingQuantity",
  case
    when ib."expiryDate" is null then null
    else ((ib."expiryDate" - public.now_millis()) / (1000 * 60 * 60 * 24))::integer
  end as "daysToExpiry"
from public.inventory_batch ib
where ib."deletedAt" is null
  and ib."remainingQuantity" > 0;

create or replace view public.v_stock_valuation as
select
  ib."ownerUuid",
  ib."storeUuid",
  ib."productUuid",
  sum(ib."remainingQuantity" * ib."unitCost")::numeric(16, 2) as "stockValue"
from public.inventory_batch ib
where ib."deletedAt" is null
group by ib."ownerUuid", ib."storeUuid", ib."productUuid";

create or replace view public.v_supplier_performance as
select
  po."ownerUuid",
  po."supplierUuid",
  count(*) as "purchaseOrderCount",
  avg(case when po.status = 'received' then 1 else 0 end)::numeric(8, 4) as "fulfillmentRate",
  avg(case when po."expectedDate" is not null and po."updatedAt" <= po."expectedDate" then 1 else 0 end)::numeric(8, 4) as "onTimeRate"
from public.purchase_order po
where po."deletedAt" is null
group by po."ownerUuid", po."supplierUuid";

create or replace view public.v_sales_profit as
select
  si."ownerUuid",
  si."storeUuid",
  si."branchUuid",
  si.uuid as "salesInvoiceUuid",
  si."totalAmount" as revenue,
  coalesce(sum(abs(it.quantity) * coalesce(it."unitCost", 0)), 0)::numeric(14, 2) as cogs,
  (si."totalAmount" - coalesce(sum(abs(it.quantity) * coalesce(it."unitCost", 0)), 0))::numeric(14, 2) as profit
from public.sales_invoice si
left join public.inventory_transaction it
  on it."referenceType" = 'sales_invoice'
 and it."referenceUuid" = si.uuid
 and it.quantity < 0
 and it."deletedAt" is null
where si."deletedAt" is null
group by si."ownerUuid", si."storeUuid", si."branchUuid", si.uuid, si."totalAmount";

create or replace function public.current_user_uuid()
returns uuid
language sql
stable
as $$
  select u.uuid from public.users u where u.auth_user_id = auth.uid() limit 1;
$$;

create or replace function public.user_has_owner_access(target_owner uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.owner_user_membership oum
    where oum."ownerUuid" = target_owner
      and oum."userUuid" = public.current_user_uuid()
      and oum.status = 1
      and oum."deletedAt" is null
  );
$$;

alter table public.owner_account enable row level security;
alter table public.owner_user_membership enable row level security;
alter table public.owner_permission_scope enable row level security;
alter table public.purchase_order enable row level security;
alter table public.purchase_order_item enable row level security;
alter table public.supplier_invoice enable row level security;
alter table public.inventory_batch enable row level security;
alter table public.inventory_transaction enable row level security;
alter table public.transfer_order enable row level security;
alter table public.transfer_order_item enable row level security;
alter table public.sales_order enable row level security;
alter table public.sales_order_item enable row level security;
alter table public.sales_invoice enable row level security;
alter table public.sales_return enable row level security;
alter table public.branch_price enable row level security;
alter table public.promotion_rule enable row level security;
alter table public.staff_shift enable row level security;
alter table public.staff_attendance enable row level security;
alter table public.staff_activity_log enable row level security;
alter table public.audit_log enable row level security;
alter table public.sync_conflict_log enable row level security;
alter table public.external_integration_endpoint enable row level security;
alter table public.notification_event enable row level security;

drop policy if exists owner_account_access on public.owner_account;
create policy owner_account_access on public.owner_account
for all to authenticated
using (public.user_has_owner_access(uuid))
with check (public.user_has_owner_access(uuid));

drop policy if exists owner_user_membership_access on public.owner_user_membership;
create policy owner_user_membership_access on public.owner_user_membership
for all to authenticated
using (public.user_has_owner_access("ownerUuid"))
with check (public.user_has_owner_access("ownerUuid"));

drop policy if exists owner_permission_scope_access on public.owner_permission_scope;
create policy owner_permission_scope_access on public.owner_permission_scope
for all to authenticated
using (
  exists (
    select 1
    from public.owner_user_membership m
    where m.uuid = "ownerMembershipUuid"
      and public.user_has_owner_access(m."ownerUuid")
  )
)
with check (
  exists (
    select 1
    from public.owner_user_membership m
    where m.uuid = "ownerMembershipUuid"
      and public.user_has_owner_access(m."ownerUuid")
  )
);

create or replace function public.create_owner_policy(target_table text)
returns void
language plpgsql
as $$
begin
  execute format('drop policy if exists authenticated_all on public.%I', target_table);
  execute format('drop policy if exists owner_policy on public.%I', target_table);
  execute format(
    'create policy owner_policy on public.%I for all to authenticated using (public.user_has_owner_access("ownerUuid")) with check (public.user_has_owner_access("ownerUuid"))',
    target_table
  );
end;
$$;

select public.create_owner_policy('store');
select public.create_owner_policy('branch');
select public.create_owner_policy('products');
select public.create_owner_policy('supplier');
select public.create_owner_policy('client');
select public.create_owner_policy('category');
select public.create_owner_policy('tags');
select public.create_owner_policy('roles');
select public.create_owner_policy('store_invoice');
select public.create_owner_policy('store_payment_voucher');
select public.create_owner_policy('store_return');
select public.create_owner_policy('store_financial_transaction');
select public.create_owner_policy('inventory_movement');
select public.create_owner_policy('purchase_order');
select public.create_owner_policy('supplier_invoice');
select public.create_owner_policy('inventory_batch');
select public.create_owner_policy('inventory_transaction');
select public.create_owner_policy('transfer_order');
select public.create_owner_policy('sales_order');
select public.create_owner_policy('sales_invoice');
select public.create_owner_policy('sales_return');
select public.create_owner_policy('branch_price');
select public.create_owner_policy('promotion_rule');
select public.create_owner_policy('staff_shift');
select public.create_owner_policy('staff_attendance');
select public.create_owner_policy('staff_activity_log');
select public.create_owner_policy('audit_log');
select public.create_owner_policy('sync_conflict_log');
select public.create_owner_policy('external_integration_endpoint');
select public.create_owner_policy('notification_event');

drop function if exists public.create_owner_policy(text);

drop policy if exists purchase_order_item_owner_policy on public.purchase_order_item;
create policy purchase_order_item_owner_policy on public.purchase_order_item
for all to authenticated
using (
  exists (
    select 1 from public.purchase_order po
    where po.uuid = "purchaseOrderUuid"
      and public.user_has_owner_access(po."ownerUuid")
  )
)
with check (
  exists (
    select 1 from public.purchase_order po
    where po.uuid = "purchaseOrderUuid"
      and public.user_has_owner_access(po."ownerUuid")
  )
);

drop policy if exists transfer_order_item_owner_policy on public.transfer_order_item;
create policy transfer_order_item_owner_policy on public.transfer_order_item
for all to authenticated
using (
  exists (
    select 1 from public.transfer_order t
    where t.uuid = "transferOrderUuid"
      and public.user_has_owner_access(t."ownerUuid")
  )
)
with check (
  exists (
    select 1 from public.transfer_order t
    where t.uuid = "transferOrderUuid"
      and public.user_has_owner_access(t."ownerUuid")
  )
);

drop policy if exists sales_order_item_owner_policy on public.sales_order_item;
create policy sales_order_item_owner_policy on public.sales_order_item
for all to authenticated
using (
  exists (
    select 1 from public.sales_order so
    where so.uuid = "salesOrderUuid"
      and public.user_has_owner_access(so."ownerUuid")
  )
)
with check (
  exists (
    select 1 from public.sales_order so
    where so.uuid = "salesOrderUuid"
      and public.user_has_owner_access(so."ownerUuid")
  )
);

-- ===== END 20260505_000004_operating_model_upgrade.sql =====

