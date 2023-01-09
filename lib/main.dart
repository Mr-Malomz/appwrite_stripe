import 'package:appwrite_stripe/user_service.dart';
import 'package:appwrite_stripe/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appwrite Stripe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weekly Newspaper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late User user;
  bool _isLoading = false;
  bool _isFetching = false;
  bool _isError = false;

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  _getUserDetails() {
    setState(() {
      _isLoading = true;
    });

    UserService().getUserDetails().then((value) {
      setState(() {
        user = value;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  _subscribe(String name) {
    setState(() {
      _isFetching = true;
    });
    UserService().createSubscription().then(
      (value) {
        UserService().subscribeUser(name).then((value) {
          setState(() {
            _isFetching = false;
            user.is_subscribed = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subscribed successfully!')),
          );
        }).catchError((e) {
          setState(() {
            _isFetching = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error processing payment!')),
          );
        });
      },
    ).catchError((e) {
      setState(() {
        _isFetching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error processing payment!')),
      );
    });
  }

  _unsubscribe(String name) {
    setState(() {
      _isFetching = true;
    });
    UserService().unSubscribeUser(name).then((value) {
      setState(() {
        _isFetching = false;
        user.is_subscribed = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsubscribed successfully!')),
      );
    }).catchError((e) {
      setState(() {
        _isFetching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error unsubscribing!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'Error getting users details',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Image(image: AssetImage('images/subscription.png')),
                      const SizedBox(height: 20),
                      const Text(
                        'Manage subscription',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'By subscribing to our service, we will deliver newspaper to you weekly',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: user.is_subscribed
                              ? const SizedBox()
                              : TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          _subscribe(user.name);
                                        },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xff1C4ED8)),
                                  ),
                                  child: const Text(
                                    'Subscribe to newspaper',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      user.is_subscribed
                          ? TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _unsubscribe(user.name);
                                    },
                              child: const Text(
                                'Unsubscribe',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ))
                          : const SizedBox()
                    ],
                  ),
                ),
              );
  }
}
