// Replace these placeholders with your Supabase project's public URL and anon key.
// Never put the service_role key here.
const SUPABASE_URL = "https://ymgesjwqbjxrbbuqkzum.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_5yYmeug74cM3G8GiIkIh5A_PKIKjgpR";

// Load the official Supabase browser library in your HTML before this file.
// Example:
// <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
// <script src="supabase_client.js"></script>

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

window.createRegistration = async function createRegistration(data) {
  const registrationId =
    "KJC2026-" + crypto.randomUUID().slice(0, 8).toUpperCase();

  const { error } = await supabaseClient
    .from("registrations")
    .insert({
      registration_id: registrationId,
      participant_name: data.name,
      class_name: data.className,
      institution: data.institution,
      contact_number: data.contact,
      email: data.email,
      event_name: data.event,
      amount: 40,
      payment_status: "PENDING"
    });

  if (error) throw error;

  return registrationId;
}
}
