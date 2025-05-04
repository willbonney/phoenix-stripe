const StripeForm = {
  mounted() {
    const stripe = Stripe(window.stripePublishableKey);
    const elements = stripe.elements();
    const form = this.el;
    const projectId = form.querySelector('input[name="project_id"]').value;
    const cardElement = form.querySelector(`#card-element-${projectId}`);
    const cardErrors = form.querySelector(`#card-errors-${projectId}`);
    
    const card = elements.create('card');
    card.mount(cardElement);

    card.addEventListener('change', ({error}) => {
      if (error) {
        cardErrors.textContent = error.message;
      } else {
        cardErrors.textContent = '';
      }
    });

    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const amount = form.querySelector('input[name="amount"]').value;

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
          this.pushEvent('payment_succeeded', { project_id: projectId, amount });
        } else {
          this.pushEvent('payment_failed', { project_id: projectId, error: result.error });
        }
      } catch (err) {
        console.error('Error:', err);
        this.pushEvent('payment_failed', { project_id: projectId, error: err.message });
      }
    });
  }
};

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
      const amount = form.amount.value;
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
        // Create payment intent with the payment method
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
          alert('Payment successful! Thank you for your support.');
        } else {
          alert('Payment failed. Please try again.');
        }
      } catch (err) {
        console.error('Error:', err);
        alert('Something went wrong. Please try again.');
      }
    });
  }
};

export default {
  StripeForm,
  PaymentFormStripe
}; 