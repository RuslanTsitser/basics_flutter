import 'package:flutter/material.dart';

class HeavyWidgetOptimizedScreen extends StatefulWidget {
  const HeavyWidgetOptimizedScreen({super.key});

  @override
  State<HeavyWidgetOptimizedScreen> createState() =>
      _HeavyWidgetOptimizedScreenState();
}

class _HeavyWidgetOptimizedScreenState
    extends State<HeavyWidgetOptimizedScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
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
