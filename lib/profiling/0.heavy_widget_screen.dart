import 'package:flutter/material.dart';

class HeavyWidgetScreen extends StatefulWidget {
  const HeavyWidgetScreen({super.key});

  @override
  State<HeavyWidgetScreen> createState() => _HeavyWidgetScreenState();
}

class _HeavyWidgetScreenState extends State<HeavyWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Heavy Widget'),
        ),
        body: const Scaffold(
          body: Scaffold(
            body: Scaffold(
              body: Scaffold(
                body: Scaffold(
                  body: Scaffold(
                    body: Scaffold(
                      body: Scaffold(
                        body: Scaffold(
                          body: Scaffold(
                            body: Scaffold(
                              body: Scaffold(
                                body: Scaffold(
                                  body: Scaffold(
                                    body: Scaffold(
                                      body: Scaffold(
                                        body: Scaffold(
                                          body: Scaffold(
                                            body: Scaffold(
                                              body: Scaffold(
                                                body: Scaffold(
                                                  body: Scaffold(
                                                    body: Scaffold(
                                                      body: Scaffold(
                                                        body: Scaffold(
                                                          body: Scaffold(
                                                            body: Scaffold(
                                                              body: Scaffold(
                                                                body: Scaffold(
                                                                  body:
                                                                      Scaffold(
                                                                    body:
                                                                        Scaffold(
                                                                      body:
                                                                          Scaffold(
                                                                        body:
                                                                            Scaffold(
                                                                          body:
                                                                              Scaffold(
                                                                            body:
                                                                                Scaffold(
                                                                              body: Scaffold(
                                                                                body: Scaffold(
                                                                                  body: Scaffold(
                                                                                    body: Scaffold(
                                                                                      body: Scaffold(
                                                                                        body: Scaffold(
                                                                                          body: Scaffold(
                                                                                            body: Scaffold(
                                                                                              body: Scaffold(
                                                                                                body: Scaffold(
                                                                                                  body: Scaffold(
                                                                                                    body: Scaffold(
                                                                                                      body: Scaffold(
                                                                                                        body: Scaffold(
                                                                                                          body: Scaffold(
                                                                                                            body: Scaffold(
                                                                                                              body: Scaffold(
                                                                                                                body: Scaffold(
                                                                                                                  body: Scaffold(
                                                                                                                    body: Scaffold(
                                                                                                                      body: Scaffold(
                                                                                                                        body: Scaffold(
                                                                                                                          body: Scaffold(
                                                                                                                            body: Scaffold(
                                                                                                                              body: Scaffold(
                                                                                                                                body: Scaffold(
                                                                                                                                  body: Scaffold(
                                                                                                                                    body: Scaffold(
                                                                                                                                      body: Scaffold(
                                                                                                                                        body: Center(
                                                                                                                                          child: ColoredBox(
                                                                                                                                            color: Colors.red,
                                                                                                                                            child: Padding(
                                                                                                                                              padding: EdgeInsets.all(16.0),
                                                                                                                                              child: _CounterWidget(),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CounterInheritedWidget extends InheritedWidget {
  const CounterInheritedWidget(
      {super.key, required super.child, required this.counter});
  final int counter;

  @override
  bool updateShouldNotify(CounterInheritedWidget oldWidget) {
    return counter != oldWidget.counter;
  }
}

class _CounterWidget extends StatelessWidget {
  const _CounterWidget();

  @override
  Widget build(BuildContext context) {
    final counter = context
            .dependOnInheritedWidgetOfExactType<CounterInheritedWidget>()
            ?.counter ??
        0;
    return SizedBox(
      width: 100,
      height: 100,
      child: Text(
        'Counter $counter',
      ),
    );
  }
}

class ButtonWrapper extends StatefulWidget {
  const ButtonWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<ButtonWrapper> createState() => _ButtonWrapperState();
}

class _ButtonWrapperState extends State<ButtonWrapper> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return CounterInheritedWidget(
      counter: _counter,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _counter++;
          });
        },
        child: widget.child,
      ),
    );
  }
}
