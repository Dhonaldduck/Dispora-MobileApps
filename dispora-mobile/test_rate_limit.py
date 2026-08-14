import requests
import time

# Konfigurasi Target (Sesuaikan port dengan server NestJS lokal)
TARGET_URL = "http://127.0.0.1:3000/auth/otp/request"

# Data payload dummy untuk request OTP
PAYLOAD = {
    "phoneNumber": "081234567890"
}

HEADERS = {
    "Content-Type": "application/json",
    "User-Agent": "Pentest-Automated-Script/1.0"
}

def run_simulation():
    print(f"[*] Memulai penetrasi Rate Limiting ke {TARGET_URL}")
    print("[*] Mengirimkan 10 request beruntun...\n")

    for i in range(1, 11):
        try:
            # Mengirimkan POST request ke endpoint
            response = requests.post(TARGET_URL, json=PAYLOAD, headers=HEADERS)
            
            # Evaluasi respons dari server NestJS
            if response.status_code in [200, 201]:
                print(f"[+] Request {i:02d}/10 - LOLOS    | Status: {response.status_code}")
            elif response.status_code == 429:
                print(f"[-] Request {i:02d}/10 - DIBLOKIR | Status: {response.status_code} (Too Many Requests)")
            else:
                print(f"[!] Request {i:02d}/10 - ANOMALI  | Status: {response.status_code} - {response.text}")
                
            # Jeda sangat singkat (100ms) untuk mensimulasikan serangan otomatis
            time.sleep(0.1)
            
        except requests.exceptions.ConnectionError:
            print("\n[!] KESALAHAN KONEKSI: Pastikan server NestJS sudah berjalan (npm run start:dev).")
            break

    print("\n[*] Simulasi selesai.")

if __name__ == "__main__":
    run_simulation()
