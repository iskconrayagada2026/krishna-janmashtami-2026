// Secure admin-login logic for the frontend.
// Requires supabase_client.js to be loaded first.

async function adminLogin(email, password) {
  const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });
  if (error) throw error;
  return data.user;
}

async function adminLogout() {
  await supabaseClient.auth.signOut();
}

async function getAdminRegistrations() {
  const { data, error } = await supabaseClient
    .from("registrations")
    .select("*")
    .order("created_at", { ascending: false });
  if (error) throw error;
  return data;
}

async function verifyRegistration(registrationId, status) {
  const { error } = await supabaseClient.rpc("verify_registration", {
    p_registration_id: registrationId,
    p_status: status
  });
  if (error) throw error;
}
