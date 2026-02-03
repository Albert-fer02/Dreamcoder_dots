// arkonyx_core/src/main.rs
use arkonyx_core::application::use_cases::CreateInvoiceUseCase;
use arkonyx_core::application::ports::{InvoiceRepository, EventPublisher};
use arkonyx_core::domain::entities::Invoice;
use arkonyx_core::domain::events::DomainEvent;
use std::env;

struct MockRepo;
impl InvoiceRepository for MockRepo {
    fn save(&self, invoice: &Invoice) -> Result<(), String> {
        println!("Persistence: Invoice {} saved to encrypted storage.", invoice.id);
        Ok(())
    }
}

struct MockPublisher;
impl EventPublisher for MockPublisher {
    fn publish(&self, event: Box<dyn DomainEvent>) -> Result<(), String> {
        println!("Audit: Event '{}' published for SUNAT tracking.", event.event_type());
        Ok(())
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 4 {
        println!("Usage: arkonyx-core <id> <amount> <currency>");
        return;
    }

    let id = args[1].clone();
    let amount: f64 = args[2].parse().unwrap_or(0.0);
    let currency = args[3].clone();

    let repo = MockRepo;
    let publ = MockPublisher;
    let use_case = CreateInvoiceUseCase {
        repository: &repo,
        publisher: &publ,
    };

    match use_case.execute(id, amount, currency) {
        Ok(_) => println!("SUCCESS: Invoice processed successfully."),
        Err(e) => println!("ERROR: {}", e),
    }
}
