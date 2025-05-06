# PhoenixStripe

### Workflow
```mermaid
sequenceDiagram
    participant Client as Client (Browser/JS Hook)
    participant Server as Phoenix Server (LiveView/Controller)
    participant Stripe as Stripe API
    Client->>Server: GET /api/stripe-key
    Server-->>Client: { stripeKey from .env }
    Note over Client: User fills payment form and clicks "Pay Now"
    Client->>Server: POST /api/create-setup-intent
    Server->>Stripe: Create SetupIntent (with secret key)
    Stripe-->>Server: SetupIntent { client_secret }
    Server-->>Client: { client_secret }
    rect rgb(200, 150, 255)
    Note over Client: Bypass Server for PCI compliance
    Client->>Stripe: confirmCardSetup(client_secret, card details)
    Stripe-->>Client: { payment_method_id }
    end
    Client->>Server: POST /api/create-payment-intent { payment_method_id, amount }
    Server->>Stripe: Create PaymentIntent (with secret key)
    Stripe-->>Server: PaymentIntent { status: succeeded/failed & payment_intent.id }
    Server-->>Client: { status: succeeded/failed & payment_intent.id }
```

First copy .env.example to .env and set the environment variables.

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
