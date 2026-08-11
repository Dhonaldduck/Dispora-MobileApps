import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';

class UserLoginScreen extends ConsumerStatefulWidget {
  const UserLoginScreen({super.key});

  @override
  ConsumerState<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends ConsumerState<UserLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _submitPhone() async {
    if (_phoneController.text.trim().isEmpty) return;
    
    final success = await ref.read(authProvider.notifier).requestOtp(_phoneController.text.trim());
    if (success) {
      setState(() {
        _isOtpSent = true;
      });
    } else {
      final error = ref.read(authProvider).errorMessage;
      if (mounted && error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  void _submitOtp() async {
    if (_otpController.text.trim().isEmpty) return;

    await ref.read(authProvider.notifier).verifyOtp(_phoneController.text.trim(), _otpController.text.trim());
    
    final authState = ref.read(authProvider);
    if (authState.status == AuthStatus.authenticated) {
      if (mounted) {
        // Navigate to home or dashboard
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
        Navigator.pop(context); // Or pushReplacement to HomeScreen
      }
    } else if (authState.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Login Pengguna'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isOtpSent ? _buildOtpForm(isLoading) : _buildPhoneForm(isLoading),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneForm(bool isLoading) {
    return Container(
      key: const ValueKey('phoneForm'),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12), // rounded-xl
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // rgba(0,0,0,0.1)
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Masukkan Nomor HP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Kami akan mengirimkan kode OTP untuk verifikasi',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Contoh: 081234567890',
              hintStyle: const TextStyle(color: Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : _submitPhone,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Kirim OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm(bool isLoading) {
    return Container(
      key: const ValueKey('otpForm'),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verifikasi OTP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan 6 digit kode yang dikirim ke\n${_phoneController.text}',
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : _submitOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Verifikasi & Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: isLoading ? null : () {
              setState(() {
                _isOtpSent = false;
                _otpController.clear();
              });
            },
            child: const Text('Ganti Nomor HP'),
          ),
        ],
      ),
    );
  }
}
