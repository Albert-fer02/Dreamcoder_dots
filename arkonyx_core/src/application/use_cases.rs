// arkonyx_core/src/application/use_cases.rs
use crate::application::ports::{InvoiceRepository, EventPublisher};
use crate::domain::entities::Invoice;
use crate::domain::events::InvoiceCreated;
use crate::domain::Invariant;
use chrono::Utc;

pub struct CreateInvoiceUseCase<'a> {
    pub repository: &'a dyn InvoiceRepository,
    pub publisher: &'a dyn EventPublisher,
}

impl<'a> CreateInvoiceUseCase<'a> {
    pub fn execute(&self, id: String, amount: f64, currency: String) -> Result<(), String> {
        let invoice = Invoice { id: id.clone(), amount, currency };
        
        // 1. Validate Invariants
        invoice.validate()?;

        // 2. Save to Repository
        self.repository.save(&invoice)?;

        // 3. Publish Event for Audit
        let event = InvoiceCreated {
            invoice_id: id,
            amount,
            timestamp: Utc::now(),
        };
        self.publisher.publish(Box::new(event))?;

        Ok(())
    }
}
