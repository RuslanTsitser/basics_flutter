import 'package:flutter/material.dart';

class HeavyWidgetOptimizedBetterScreen extends StatefulWidget {
  const HeavyWidgetOptimizedBetterScreen({super.key});

  @override
  State<HeavyWidgetOptimizedBetterScreen> createState() =>
      _HeavyWidgetOptimizedBetterScreenState();
}

class _HeavyWidgetOptimizedBetterScreenState
    extends State<HeavyWidgetOptimizedBetterScreen> {
  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Heavy Widget with const and Separated Widget'),
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
                                                                                                                                              child: Text(
                                                                                                                                                'Press me and check the Performance View!',
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
      ),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({required this.child});
  final Widget child;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: widget.child,
    );
  }
}
