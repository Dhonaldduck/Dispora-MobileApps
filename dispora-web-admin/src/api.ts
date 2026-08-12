import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:3000',
  timeout: 10000,
});

api.interceptors.request.use(
  (config) => {
    // Attempt to parse Zustand store from localStorage to get token
    try {
      const authStorageStr = localStorage.getItem('auth-storage');
      if (authStorageStr) {
        const parsedStore = JSON.parse(authStorageStr);
        const token = parsedStore?.state?.token;
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
      }
    } catch (error) {
      console.error('Error parsing token from storage:', error);
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    // Handle 401 Unauthorized globally if needed (e.g. force logout)
    return Promise.reject(error);
  }
);

export default api;
