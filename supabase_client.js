// Replace these placeholders with your Supabase project's public URL and anon key.
// Never put the service_role key here.
const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";

// Load the official Supabase browser library in your HTML before this file.
// Example:
// <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
// <script src="supabase_client.js"></script>

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function createRegistration(data) {
  const registrationId = "KJC2026-" + crypto.randomUUID().slice(0, 8).toUpperCase();
  const { data: row, error } = await supabaseClient
    .from("registrations")
    .insert({
      registration_id: registrationId,
      participant_name: data.name,
      class_name: data.className,
      institution: data.institution,
      contact_number: data.contact,
      event_name: data.event,
      amount: 40,
      payment_status: "PENDING"
    })
    .select("registration_id")
    .single();

  if (error) throw error;
  return row.registration_id;
}
