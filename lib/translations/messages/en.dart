Map<String, String> get keys {
  return {
    'error': 'Error',
    'exception': 'Exception',
    'exception_message':
        'Oops, something went wrong. Please try again later. @reason',
    'quit': 'Quit',
    // login
    'login.title': 'Log in to your account',
    'login.description': 'You are connected to @baseUrl.',
    'login.email': 'Email',
    'login.email_hint': 'Enter your email',
    'login.email_invalid': 'Enter a valid email',
    'login.password': 'Password',
    'login.password_hint': 'Enter your password',
    'login.password_invalid': 'Enter a valid password',
    'login.submit': 'Sign In',
    'login.change_url': 'Change URL',
    'login.forgot_password': 'Forgot your password?',
    // forgot_password
    'forgot_password.title': 'Forgot Password?',
    'forgot_password.description': 'Don\'t worry! We got your back',
    // change_url
    'change_url.title': 'Installation URL',
    'change_url.description':
        'If you are using a self-hosted Chatwoot installation, input your server URL. Otherwise, use @baseUrl.',
    'change_url.url': 'URL',
    'change_url.url_hint': 'Enter your URL without http',
    'change_url.submit': 'Verify',
    // conversation_input
    'conversation_input.message_hint': 'Type message...',
  };
}
