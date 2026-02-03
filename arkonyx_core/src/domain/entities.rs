// core/src/domain/entities.rs
use crate::domain::Invariant;

pub struct Invoice {
    pub id: String,
    pub amount: f64,
    pub currency: String,
}

impl Invariant for Invoice {
    fn validate(&self) -> Result<(), String> {
        if self.amount <= 0.0 {
            return Err("Amount must be greater than zero".into());
        }
        if self.id.is_empty() {
            return Err("Invoice ID cannot be empty".into());
        }
        Ok(())
    }
}
