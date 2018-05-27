async function startApp() {
    // Configure the ABIs
    await initDApp();
    // Get the Required Account Details
    await fetchAccountDetails();
}