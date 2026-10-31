import 'package:flutter/material.dart';

import 'simple_app.dart';
import 'services/api_auth_service.dart';

void main() => runApp(SimpleApp(auth: ApiAuthService()));
