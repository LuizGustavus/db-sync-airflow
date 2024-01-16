CREATE TABLE public.user (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(20)
);

INSERT INTO public.user (name, surname, phone) VALUES
  ('John', 'Doe', '123-456-7890'),
  ('Alice', 'Smith', '987-654-3210'),
  ('Bob', 'Johnson', '555-123-4567'),
  ('Jane', 'Doe', '111-222-3333'),
  ('Tom', 'Williams', '444-555-6666'),
  ('Sara', 'Miller', '777-888-9999'),
  ('Emily', 'Davis', '333-222-1111'),
  ('Michael', 'Wilson', '999-888-7777'),
  ('Grace', 'Taylor', '666-555-4444'),
  ('Daniel', 'Brown', '222-333-4444'),
  ('Olivia', 'Lee', '111-444-7777'),
  ('Henry', 'Moore', '555-999-1111'),
  ('Ella', 'Clark', '777-111-4444'),
  ('Matthew', 'Green', '888-333-5555'),
  ('Sophia', 'Jones', '999-111-2222');
