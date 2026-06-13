┌───────────────┐
                     │   AIRPORT     │
                     │ PK airport_id │
                     │ name          │
                     │ city          │
                     │ country       │
                     └──────┬────────┘
                            │ 1
          ┌─────────────────┼─────────────────┐
          │                                   │
          ▼                                   ▼
┌──────────────────────┐        ┌──────────────────────┐
│       FLIGHT         │        │       FLIGHT         │
│ PK flight_id         │        │ PK flight_id         │
│ flight_number        │        │ flight_number        │
│ source_airport_id FK │        │ destination_airport FK│
│ departure_time       │        │ arrival_time         │
│ aircraft_id FK       │        └─────────┬────────────┘
└──────────┬───────────┘                  │
           │ M                            │ M
           │                              │
           ▼                              ▼
     ┌───────────────┐            ┌───────────────┐
     │   AIRPORT     │            │   AIRPORT     │
     └───────────────┘            └───────────────┘


────────────────────────────────────────────────────────


┌──────────────────────┐      1        M      ┌──────────────────────┐
│     PASSENGER        │──────────────────────▶│       BOOKING        │
│ PK passenger_id      │                      │ PK booking_id        │
│ name                 │                      │ passenger_id FK      │
│ email                │                      │ flight_id FK         │
└──────────────────────┘                      │ seat_number          │
                                              │ booking_status       │
                                              └─────────┬────────────┘
                                                        │ 1
                                                        │
                                                        ▼
                                              ┌──────────────────────┐
                                              │      PAYMENT         │
                                              │ PK payment_id        │
                                              │ booking_id FK        │
                                              │ amount               │
                                              │ payment_method       │
                                              └──────────────────────┘


────────────────────────────────────────────────────────


┌──────────────────────┐        M        M     ┌──────────────────────┐
│       FLIGHT         │───────────────────────▶│    CREW_MEMBER       │
│ PK flight_id         │                       │ PK crew_id           │
└──────────┬───────────┘                       │ crew_name            │
           │                                   │ role                 │
           │                                   └──────────────────────┘
           │
           ▼
┌──────────────────────┐
│    FLIGHT_CREW       │   (BRIDGE TABLE)
│ flight_id FK         │
│ crew_id FK           │
└──────────────────────┘