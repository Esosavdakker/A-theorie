import { Router } from 'express';
import { createPayment, mollieWebhook, checkAccess } from '../controllers/paymentController.js';

const router = Router();

router.post('/payment/create', createPayment);
router.get('/payment/access/:userId/:courseId', checkAccess);
router.post('/webhooks/mollie', mollieWebhook);

export default router;
