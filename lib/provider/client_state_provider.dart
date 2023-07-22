import 'package:flutter/material.dart';

import '../model/client_state.dart';

class ClientStateProvider extends ChangeNotifier {
  ClientState _clientState = ClientState(
    timer: {'countDown': '', 'msg': ''},
  );

  Map<String, dynamic> get clientState => _clientState.toMap();

  setClinetState(timer) {
    _clientState = ClientState(timer: timer);
    notifyListeners();
  }
}
