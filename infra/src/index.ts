// infra/src/index.ts
import { SunatAdapter } from "./adapters/sunat_adapter";

const sunat = new SunatAdapter();

async function processInvoice() {
  console.log("🚀 Starting Infrastructure Bridge...");

  // Simulated call to the Rust Core via CLI (MVP Bridge)
  const proc = Bun.spawn(["cargo", "run", "--manifest-path", "../arkonyx_core/Cargo.toml", "--", "INV-2026-001", "1500.50", "PEN"], {
    stdout: "inherit",
    stderr: "inherit",
  });

  await proc.exited;

  // Follow-up with SUNAT adapter
  const result = await sunat.signInvoice({ id: "INV-2026-001" });
  console.log("✅ Bridge Transaction Complete:", result);
}

processInvoice();
