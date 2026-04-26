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