import 'package:flutter/material.dart';

import 'simple_app.dart';
import 'services/auth_service.dart';

void main() => runApp(const SimpleApp(auth: MockAuthService()));
