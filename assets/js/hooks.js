const PaymentFormStripe = {
  mounted() {
    const stripe = Stripe(window.stripePublishableKey);
    const elements = stripe.elements();
    const card = elements.create('card');
    card.mount(this.el.querySelector('#card-element'));
    const form = this.el.querySelector('#payment-form');
    const cardErrors = this.el.querySelector('#card-errors');
    card.addEventListener('change', ({error}) => {
      if (error) {
        cardErrors.textContent = error.message;
      } else {
        cardErrors.textContent = '';
      }
    });
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const {amount: {value: amount}} = form;
      try {
        const setupResponse = await fetch('/api/create-setup-intent', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          }
        });
        const { client_secret } = await setupResponse.json();
        const { setupIntent, error } = await stripe.confirmCardSetup(client_secret, {
          payment_method: {
            card,
            billing_details: {
              email: 'test@example.com'
            }
          }
        });
        if (error) {
          cardErrors.textContent = error.message;
          return;
        }
        const paymentResponse = await fetch('/api/create-payment-intent', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            payment_method_id: setupIntent.payment_method,
            amount
          })
        });
        const result = await paymentResponse.json();
        if (result.status === 'succeeded') {
          this.pushEvent('payment_succeeded', { amount });
        } else {
          this.pushEvent('payment_failed', { error: result.error });
        }
      } catch (err) {
        console.error('Error:', err);
        this.pushEvent('payment_failed', { error: err.message });
      }
    });
  }
};

export default {
  PaymentFormStripe
}; 