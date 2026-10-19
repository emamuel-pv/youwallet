-- YouWallet: copia en la nube de los datos de la app.
-- Cada fila es un registro de una colección (txns, accounts, cats, ...) o los ajustes (coll = 'settings').
-- Cada usuario solo puede ver y cambiar sus propias filas (RLS).

create table if not exists public.registros (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  coll text not null,
  id text not null,
  data jsonb,
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, coll, id)
);

create index if not exists registros_user_updated on public.registros (user_id, updated_at);

alter table public.registros enable row level security;

drop policy if exists "registros: ver los propios" on public.registros;
create policy "registros: ver los propios" on public.registros
  for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "registros: crear los propios" on public.registros;
create policy "registros: crear los propios" on public.registros
  for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "registros: cambiar los propios" on public.registros;
create policy "registros: cambiar los propios" on public.registros
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "registros: borrar los propios" on public.registros;
create policy "registros: borrar los propios" on public.registros
  for delete to authenticated using ((select auth.uid()) = user_id);

revoke all on public.registros from anon;
grant select, insert, update, delete on public.registros to authenticated;

-- La hora de cambio la pone el servidor, para que la sincronización no dependa del reloj del teléfono.
create or replace function public.registros_touch()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists registros_touch on public.registros;
create trigger registros_touch
  before insert or update on public.registros
  for each row execute function public.registros_touch();
