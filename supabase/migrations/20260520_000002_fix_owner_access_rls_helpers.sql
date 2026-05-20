create or replace function public.current_user_uuid()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select u.uuid
  from public.users u
  where u.auth_user_id = auth.uid()
  limit 1;
$$;

create or replace function public.user_has_owner_access(target_owner uuid)
returns boolean
language sql
stable
security definer
set search_path = public
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