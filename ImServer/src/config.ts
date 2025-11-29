import * as dotenv from 'dotenv';
dotenv.config();

const required = (value: string | undefined, name: string) => {
  if (!value) {
    throw new Error(`Missing required env: ${name}`);
  }
  return value;
};

export const config = {
  port: parseInt(process.env.PORT ?? '6001', 10),
  wsPath: process.env.WS_PATH ?? '/ws',
  supabaseUrl: required(process.env.SUPABASE_URL, 'SUPABASE_URL'),
  supabaseKey: required(process.env.SUPABASE_SERVICE_KEY, 'SUPABASE_SERVICE_KEY'),
  jwtSecret: required(process.env.JWT_SECRET_KEY, 'JWT_SECRET_KEY'),
  schema: process.env.SUPABASE_SCHEMA ?? 'public',
};
