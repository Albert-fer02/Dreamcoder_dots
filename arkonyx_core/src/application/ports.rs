// arkonyx_core/src/application/ports.rs
// Ports define the interfaces that Infrastructure must implement

use crate::domain::entities::Invoice;
use crate::domain::events::DomainEvent;

pub trait InvoiceRepository {
    fn save(&self, invoice: &Invoice) -> Result<(), String>;
}

pub trait EventPublisher {
    fn publish(&self, event: Box<dyn DomainEvent>) -> Result<(), String>;
}
