async function testNews() {
  try {
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
    console.log('Got token:', token.substring(0, 20) + '...');

    const newsRes = await fetch('http://localhost:3000/news', {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}` 
      },
      body: JSON.stringify({
        title: 'Test News ' + Date.now(),
        content: 'This is a test content',
        thumbnailUrl: '',
        isPublished: true
      })
    });
    
    if (!newsRes.ok) {
      const errorData = await newsRes.json();
      console.error('Error response:', newsRes.status, errorData);
    } else {
      const data = await newsRes.json();
      console.log('News created successfully:', data);
    }
  } catch (err) {
    console.error('Error:', err.message);
  }
}

testNews();
