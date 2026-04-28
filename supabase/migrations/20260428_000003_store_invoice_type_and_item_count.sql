alter table public.store_invoice
add column if not exists "invoiceType" text not null default 'cash' check ("invoiceType" in ('cash', 'credit')),
add column if not exists "itemCount" integer not null default 0 check ("itemCount" >= 0);