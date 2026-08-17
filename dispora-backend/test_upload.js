const fs = require('fs');
const path = require('path');

async function testUpload() {
  try {
    // 1. Get token
    const loginRes = await fetch('http://localhost:3000/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: 'admin@dispora.semarangkota.go.id',
        password: 'admin123'
      })
    });
    const loginData = await loginRes.json();
    const token = loginData.access_token;

    // 2. Upload file with fetch (which behaves similar if we manually set Content-Type without boundary)
    // Actually let's use the exact code the frontend would use, but we don't have axios in backend.
    // I can install axios just for this test, or I can use curl to see the server error if boundary is missing.
    
    // Instead of script, let's just create a dummy file and upload via curl with bad header.
  } catch (err) {
    console.error(err);
  }
}

testUpload();
