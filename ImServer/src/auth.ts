import jwt from 'jsonwebtoken';
import { config } from './config';
import { JwtClaims, UserRole } from './types';

export interface AuthedUser {
  id: number;
  role: UserRole;
  raw: JwtClaims;
}

export function verifyToken(token?: string): AuthedUser {
  if (!token) {
    throw new Error('缺少 token');
  }

  const payload = jwt.verify(token.replace(/^Bearer\s+/i, ''), config.jwtSecret) as JwtClaims;
  const id = payload.sub ? Number(payload.sub) : undefined;
  if (!id || Number.isNaN(id)) {
    throw new Error('token 中缺少用户ID');
  }
  const role = (payload.user_type as UserRole | undefined) ?? 'user';
  return { id, role, raw: payload };
}
