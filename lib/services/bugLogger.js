import { nanoid } from 'nanoid';

const bugLogs = [];

export function createBugLog({
  source = 'backend',
  type = 'error',
  message = 'Unknown error',
  stack = null,
  route = null,
  method = null,
  ip = null,
  userAgent = null,
  origin = null,
  client = null,
  extra = {},
}) {
  const bug = {
    id: nanoid(14),
    source,
    type,
    message: safeText(message, 500),
    stack: stack ? safeText(stack, 3000) : null,
    route,
    method,
    ip,
    userAgent,
    origin,
    client,
    extra,
    createdAt: new Date().toISOString(),
  };

  bugLogs.unshift(bug);

  if (bugLogs.length > 250) {
    bugLogs.pop();
  }

  console.error('[rerez_bug]', {
    id: bug.id,
    source: bug.source,
    type: bug.type,
    message: bug.message,
    route: bug.route,
    method: bug.method,
    createdAt: bug.createdAt,
  });

  return bug;
}

export function listBugLogs(limit = 50) {
  return bugLogs.slice(0, limit).map((bug) => ({
    id: bug.id,
    source: bug.source,
    type: bug.type,
    message: bug.message,
    route: bug.route,
    method: bug.method,
    ip: bug.ip,
    origin: bug.origin,
    client: bug.client,
    createdAt: bug.createdAt,
    extra: bug.extra,
  }));
}

export function getBugLog(id) {
  return bugLogs.find((bug) => bug.id === id) || null;
}

export function clearBugLogs() {
  bugLogs.length = 0;
}

export function errorToBugLog(error, req, extra = {}) {
  return createBugLog({
    source: 'backend',
    type: error?.name || 'Error',
    message: error?.message || 'Unknown backend error',
    stack: error?.stack || null,
    route: req?.originalUrl || req?.url || null,
    method: req?.method || null,
    ip: getClientIp(req),
    userAgent: req?.headers?.['user-agent'] || null,
    origin: req?.headers?.origin || null,
    client: req?.headers?.['x-rerez-client'] || null,
    extra,
  });
}

function getClientIp(req) {
  const forwardedFor = req?.headers?.['x-forwarded-for'];

  if (typeof forwardedFor === 'string' && forwardedFor.length > 0) {
    return forwardedFor.split(',')[0].trim();
  }

  return req?.ip || req?.socket?.remoteAddress || 'unknown';
}

function safeText(value, maxLength) {
  return String(value || '')
    .replace(/[<>]/g, '')
    .slice(0, maxLength);
}
