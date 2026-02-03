// arkonyx_core/src/domain/events/mod.rs
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

pub trait DomainEvent: Serialize {
    fn occurred_at(&self) -> DateTime<Utc>;
    fn event_type(&self) -> &str;
}

#[derive(Serialize, Deserialize)]
pub struct InvoiceCreated {
    pub invoice_id: String,
    pub amount: f64,
    pub timestamp: DateTime<Utc>,
}

impl DomainEvent for InvoiceCreated {
    fn occurred_at(&self) -> DateTime<Utc> {
        self.timestamp
    }
    fn event_type(&self) -> &str {
        "InvoiceCreated"
    }
}

pub struct EventStore {
    events: Vec<Box<dyn DomainEvent>>,
}

impl EventStore {
    pub fn new() -> Self {
        Self { events: Vec::new() }
    }

    pub fn record<E: DomainEvent + 'static>(&mut self, event: E) {
        self.events.push(Box::new(event));
    }

    pub fn get_events(&self) -> &Vec<Box<dyn DomainEvent>> {
        &self.events
    }
}
