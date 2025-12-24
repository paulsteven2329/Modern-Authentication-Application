import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:email_validator/email_validator.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_event.dart';
import '../utils/constants.dart';
import 'glass_container.dart';

class MagicLinkForm extends StatefulWidget {
  const MagicLinkForm({Key? key}) : super(key: key);

  @override
  State<MagicLinkForm> createState() => _MagicLinkFormState();
}

class _MagicLinkFormState extends State<MagicLinkForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = EmailValidator.validate(email);
    });
  }

  void _sendMagicLink() {
    if (_formKey.currentState!.validate() && _isEmailValid) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(_emailController.text.trim()),
      );
    }
  }

  void _resendMagicLink(String email) {
    context.read<AuthBloc>().add(AuthResendMagicLinkRequested(email));
  }

  void _editEmail() {
    setState(() {
      _emailController.clear();
      _isEmailValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isMagicLinkSent && state.lastSentEmail != null) {
          return _buildMagicLinkSentView(state);
        }

        return _buildEmailForm(state);
      },
    );
  }

  Widget _buildEmailForm(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email label
          Text(
            AppStrings.emailAddress,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Email input with icon
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: _validateEmail,
            onFieldSubmitted: (_) => _sendMagicLink(),
            decoration: InputDecoration(
              hintText: AppStrings.enterEmail,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey[600],
              ),
              suffixIcon: _isEmailValid 
                  ? Icon(Icons.check_circle, color: Colors.green[600])
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 24),
          
          // Send button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: state.isLoading || !_isEmailValid ? null : _sendMagicLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, size: 18),
                        const SizedBox(width: 8),
                        Text(AppStrings.sendMagicLink),
                      ],
                    ),
            ),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 12),
          
          // Helper text
          Text(
            'We\'ll send you a secure link to sign in without a password',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildMagicLinkSentView(AuthState state) {
    return Column(
      children: [
        // Email icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            Icons.mark_email_read,
            size: 40,
            color: Colors.blue[600],
          ),
        )
            .animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut),
        
        const SizedBox(height: 24),
        
        // Title
        Text(
          AppStrings.checkYourEmail,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 600.ms),
        
        const SizedBox(height: 8),
        
        // Description
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            children: [
              TextSpan(text: AppStrings.magicLinkSent + ' '),
              TextSpan(
                text: state.lastSentEmail,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 600.ms),
        
        const SizedBox(height: 8),
        
        Text(
          AppStrings.magicLinkInstructions,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 600.ms),
        
        const SizedBox(height: 24),
        
        // Security notice
        GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⚠️ ${AppStrings.securityNotice}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• This link will expire in ${AppConstants.magicLinkExpirationMinutes} minutes\n'
                '• It can only be used once\n'
                '• Don\'t share this link with anyone',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
            .animate(delay: 500.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 24),
        
        // Action buttons
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isLoading 
                    ? null 
                    : () => _resendMagicLink(state.lastSentEmail!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 18),
                          const SizedBox(width: 8),
                          Text(AppStrings.resendMagicLink),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            TextButton(
              onPressed: _editEmail,
              child: Text(
                AppStrings.useDifferentEmail,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        )
            .animate(delay: 600.ms)
            .fadeIn(duration: 600.ms),
      ],
    );
  }
}