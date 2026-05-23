create or replace function public.is_public_registration_open()
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  return not exists (
    select 1
    from public.owner_user_membership oum
    where oum."deletedAt" is null
      and lower(coalesce(oum.role, '')) = 'owner'
  )
  and not exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.uuid = ur."roleUuid"
    where ur."deletedAt" is null
      and r."deletedAt" is null
      and lower(coalesce(r.name, '')) = 'owner'
  )
  and not exists (
    select 1
    from public.owner_account oa
    where oa."deletedAt" is null
  );
end;
$$;

create or replace function public.prevent_public_signup_after_owner_bootstrap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  request_role text;
begin
  request_role := lower(coalesce(current_setting('request.jwt.claim.role', true), ''));

  if request_role = 'service_role' then
    return new;
  end if;

  if not public.is_public_registration_open() then
    raise exception using errcode = 'P0001', message = 'public_registration_closed';
  end if;

  return new;
end;
$$;

grant execute on function public.is_public_registration_open() to anon, authenticated, service_role;

drop trigger if exists before_auth_user_signup_registration_gate on auth.users;

create trigger before_auth_user_signup_registration_gate
before insert on auth.users
for each row execute function public.prevent_public_signup_after_owner_bootstrap();