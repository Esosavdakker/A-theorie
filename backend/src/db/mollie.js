import { createMollieClient } from '@mollie/api-client';

let mollie;

export function getMollie() {
  if (!mollie) {
    mollie = createMollieClient({ apiKey: process.env.MOLLIE_API_KEY });
  }
  return mollie;
}
