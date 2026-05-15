// src/hooks/useMollie.js

import { useState } from 'react';

const BACKEND_URL = import.meta.env.VITE_BACKEND_URL;

export function useMollie() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  async function startPayment({ userId, courseId }) {
    setLoading(true);
    setError(null);

    try {
      const res = await fetch(`${BACKEND_URL}/payment/create`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId, courseId }),
      });

      const data = await res.json();

      if (!res.ok) throw new Error(data.error || 'Payment failed');

      window.location.href = data.checkoutUrl;
    } catch (err) {
      setError(err.message);
      setLoading(false);
    }
  }

  return { startPayment, loading, error };
}


// src/components/BuyButton.jsx

import { useMollie } from '../hooks/useMollie';

export function BuyButton({ courseId, userId }) {
  const { startPayment, loading, error } = useMollie();

  return (
    <div>
      <button
        onClick={() => startPayment({ userId, courseId })}
        disabled={loading}
        className="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-xl disabled:opacity-50"
      >
        {loading ? 'Bezig...' : 'Betalen met iDEAL'}
      </button>
      {error && <p className="text-red-500 mt-2 text-sm">{error}</p>}
    </div>
  );
}


// src/pages/PaymentReturn.jsx
// Route: /payment/return

import { useEffect, useState } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';

const BACKEND_URL = import.meta.env.VITE_BACKEND_URL;

export function PaymentReturn() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const courseId = searchParams.get('courseId');
  const [status, setStatus] = useState('checking');

  useEffect(() => {
    const userId = localStorage.getItem('userId');
    if (!userId || !courseId) return;

    let attempts = 0;

    const poll = async () => {
      try {
        const res = await fetch(`${BACKEND_URL}/payment/access/${userId}/${courseId}`);
        const data = await res.json();

        if (data.hasAccess) {
          setStatus('success');
          setTimeout(() => navigate(`/cursussen/${courseId}`), 2000);
        } else if (attempts < 6) {
          attempts++;
          setTimeout(poll, 2000);
        } else {
          setStatus('pending');
        }
      } catch {
        setStatus('pending');
      }
    };

    poll();
  }, [courseId, navigate]);

  return (
    <div className="flex flex-col items-center justify-center min-h-screen text-center p-8">
      {status === 'checking' && (
        <>
          <div className="animate-spin text-4xl mb-4">⏳</div>
          <h1 className="text-2xl font-bold">Betaling verwerken...</h1>
          <p className="text-gray-500 mt-2">Even geduld, dit duurt maar een moment.</p>
        </>
      )}
      {status === 'success' && (
        <>
          <div className="text-5xl mb-4">✅</div>
          <h1 className="text-2xl font-bold">Betaling geslaagd!</h1>
          <p className="text-gray-500 mt-2">Je wordt doorgestuurd naar de cursus...</p>
        </>
      )}
      {status === 'pending' && (
        <>
          <div className="text-5xl mb-4">🕐</div>
          <h1 className="text-2xl font-bold">We verwerken je betaling</h1>
          <p className="text-gray-500 mt-2">
            Dit kan soms een minuutje duren. Je ontvangt een bevestiging zodra de cursus klaarstaat.
          </p>
        </>
      )}
    </div>
  );
}


// Add to your React .env:
// VITE_BACKEND_URL=https://your-backend.railway.app
// (for local dev: VITE_BACKEND_URL=http://localhost:3000)
