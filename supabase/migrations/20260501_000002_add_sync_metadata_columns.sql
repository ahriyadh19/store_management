do $$
declare
  table_name text;
  target_tables text[] := array[
    'users',
    'company',
    'products',
    'categories',
    'tags',
    'roles',
    'store',
    'client',
    'company_products',
    'products_tags',
    'user_roles',
    'store_company',
    'store_client',
    'store_user',
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
    execute format(
      'alter table if exists public.%I add column if not exists synced boolean not null default false',
      table_name
    );
    execute format(
      'alter table if exists public.%I add column if not exists "deletedAt" bigint',
      table_name
    );
    execute format(
      'alter table if exists public.%I add column if not exists "syncedAt" bigint',
      table_name
    );
  end loop;
end
$$;