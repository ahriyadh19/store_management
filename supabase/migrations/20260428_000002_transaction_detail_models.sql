alter table public.company_products
  add column if not exists "costPrice" numeric(12, 2) check ("costPrice" >= 0),
  add column if not exists sku text,
  add column if not exists barcode text,
  add column if not exists "reorderLevel" integer check ("reorderLevel" >= 0),
  add column if not exists "reorderQuantity" integer check ("reorderQuantity" >= 0);

create table if not exists public.store_invoice_item (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "invoiceId" bigint not null,
    "invoiceUuid" uuid not null,
    "companyProductId" bigint not null,
    "companyProductUuid" uuid not null,
    "productId" bigint not null,
    "productUuid" uuid not null,
    quantity integer not null check (quantity > 0),
    "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
    "discountAmount" numeric(12, 2) not null default 0 check ("discountAmount" >= 0),
    "taxAmount" numeric(12, 2) not null default 0 check ("taxAmount" >= 0),
    "lineTotal" numeric(12, 2) not null check ("lineTotal" >= 0),
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint store_invoice_item_invoice_fk foreign key ("invoiceId", "invoiceUuid") references public.store_invoice (id, uuid) on delete cascade,
    constraint store_invoice_item_company_product_fk foreign key ("companyProductId", "companyProductUuid") references public.company_products (id, uuid) on delete restrict,
    constraint store_invoice_item_product_fk foreign key ("productId", "productUuid") references public.products (id, uuid) on delete restrict
);

create table if not exists public.store_return_item (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "returnId" bigint not null,
    "returnUuid" uuid not null,
    "invoiceItemId" bigint,
    "invoiceItemUuid" uuid,
    "companyProductId" bigint not null,
    "companyProductUuid" uuid not null,
    "productId" bigint not null,
    "productUuid" uuid not null,
    quantity integer not null check (quantity > 0),
    "unitPrice" numeric(12, 2) not null check ("unitPrice" >= 0),
    "lineTotal" numeric(12, 2) not null check ("lineTotal" >= 0),
    reason text not null default '',
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint store_return_item_return_fk foreign key ("returnId", "returnUuid") references public.store_return (id, uuid) on delete cascade,
    constraint store_return_item_invoice_item_fk foreign key ("invoiceItemId", "invoiceItemUuid") references public.store_invoice_item (id, uuid) on delete set null,
    constraint store_return_item_company_product_fk foreign key ("companyProductId", "companyProductUuid") references public.company_products (id, uuid) on delete restrict,
    constraint store_return_item_product_fk foreign key ("productId", "productUuid") references public.products (id, uuid) on delete restrict
);

create table if not exists public.inventory_movement (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "companyProductId" bigint not null,
    "companyProductUuid" uuid not null,
    "productId" bigint not null,
    "productUuid" uuid not null,
    "movementType" text not null,
    "quantityDelta" integer not null check ("quantityDelta" <> 0),
    "balanceAfter" integer not null check ("balanceAfter" >= 0),
    "unitCost" numeric(12, 2) check ("unitCost" >= 0),
    "referenceType" text not null,
    "referenceId" bigint,
    "referenceUuid" uuid,
    note text not null default '',
    "createdByUserId" bigint,
    "createdByUserUuid" uuid,
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint inventory_movement_company_product_fk foreign key ("companyProductId", "companyProductUuid") references public.company_products (id, uuid) on delete restrict,
    constraint inventory_movement_product_fk foreign key ("productId", "productUuid") references public.products (id, uuid) on delete restrict,
    constraint inventory_movement_user_fk foreign key ("createdByUserId", "createdByUserUuid") references public.users (id, uuid) on delete set null
);

create table if not exists public.payment_allocation (
    id bigint generated always as identity primary key,
    uuid uuid not null default gen_random_uuid() unique,
    "paymentVoucherId" bigint not null,
    "paymentVoucherUuid" uuid not null,
    "invoiceId" bigint not null,
    "invoiceUuid" uuid not null,
    "allocatedAmount" numeric(12, 2) not null check ("allocatedAmount" > 0),
    "allocationDate" bigint not null,
    status integer not null default 1 check (status in (0, 1)),
    "createdAt" bigint not null default public.now_millis(),
    "updatedAt" bigint not null default public.now_millis(),
    constraint payment_allocation_payment_voucher_fk foreign key ("paymentVoucherId", "paymentVoucherUuid") references public.store_payment_voucher (id, uuid) on delete cascade,
    constraint payment_allocation_invoice_fk foreign key ("invoiceId", "invoiceUuid") references public.store_invoice (id, uuid) on delete cascade,
    constraint payment_allocation_payment_invoice_unique unique ("paymentVoucherId", "invoiceId")
);

create index if not exists idx_store_invoice_item_invoice_id on public.store_invoice_item ("invoiceId");
create index if not exists idx_store_invoice_item_company_product_id on public.store_invoice_item ("companyProductId");
create index if not exists idx_store_return_item_return_id on public.store_return_item ("returnId");
create index if not exists idx_store_return_item_company_product_id on public.store_return_item ("companyProductId");
create index if not exists idx_inventory_movement_company_product_id on public.inventory_movement ("companyProductId");
create index if not exists idx_inventory_movement_reference on public.inventory_movement ("referenceType", "referenceId");
create index if not exists idx_payment_allocation_payment_voucher_id on public.payment_allocation ("paymentVoucherId");
create index if not exists idx_payment_allocation_invoice_id on public.payment_allocation ("invoiceId");

drop trigger if exists set_store_invoice_item_updated_at on public.store_invoice_item;
create trigger set_store_invoice_item_updated_at before update on public.store_invoice_item for each row execute function public.set_updated_at();

drop trigger if exists set_store_return_item_updated_at on public.store_return_item;
create trigger set_store_return_item_updated_at before update on public.store_return_item for each row execute function public.set_updated_at();

drop trigger if exists set_inventory_movement_updated_at on public.inventory_movement;
create trigger set_inventory_movement_updated_at before update on public.inventory_movement for each row execute function public.set_updated_at();

drop trigger if exists set_payment_allocation_updated_at on public.payment_allocation;
create trigger set_payment_allocation_updated_at before update on public.payment_allocation for each row execute function public.set_updated_at();

alter table public.store_invoice_item enable row level security;
alter table public.store_return_item enable row level security;
alter table public.inventory_movement enable row level security;
alter table public.payment_allocation enable row level security;

drop policy if exists store_invoice_item_authenticated_all on public.store_invoice_item;
create policy store_invoice_item_authenticated_all on public.store_invoice_item for all to authenticated using (true) with check (true);

drop policy if exists store_return_item_authenticated_all on public.store_return_item;
create policy store_return_item_authenticated_all on public.store_return_item for all to authenticated using (true) with check (true);

drop policy if exists inventory_movement_authenticated_all on public.inventory_movement;
create policy inventory_movement_authenticated_all on public.inventory_movement for all to authenticated using (true) with check (true);

drop policy if exists payment_allocation_authenticated_all on public.payment_allocation;
create policy payment_allocation_authenticated_all on public.payment_allocation for all to authenticated using (true) with check (true);