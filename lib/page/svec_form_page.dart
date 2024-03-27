import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:svec/settings_overlay.dart';
import 'package:svec/svec_form_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SvecFormPage extends StatefulWidget {
  const SvecFormPage({super.key, required this.title});

  final String title;

  @override
  State<SvecFormPage> createState() => _SvecHomePageState();
}

class _SvecHomePageState extends State<SvecFormPage> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

    Drawer drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 65,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Text('Useful Links'),
            ),
          ),
          ListTile(
            title: const Text('Stardew Wiki'),
            trailing: const Icon(Icons.launch),
            onTap: () async {
              _launchUrl('https://stardewvalleywiki.com/Modding:Index');
            },
          ),
          ListTile(
            title: const Text('The Great ID Spreadsheet'),
            trailing: const Icon(Icons.launch),
            onTap: () async {
              _launchUrl('https://docs.google.com/spreadsheets/d/1CpDrw23peQiq-C7F2FjYOMePaYe0Rc9BwQsj3h6sjyo');
            },
          ),
          ListTile(
            title: const Text('My Discord'),
            trailing: const Icon(Icons.launch),
            onTap: () async {
              _launchUrl('https://discord.com/invite/EPFcHVjK8p');
            },
          ),
          ListTile(
            title: const Text('Settings'),
            trailing: const Icon(Icons.settings),
            onTap: () async {
              Navigator.pop(context);
              Navigator.push(context, SettingsOverlay());
            },
          ),
        ],
      ),
    );

    if (isMobile) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            const SliverToBoxAdapter(child: SvecFormWidget())
          ],
        ),
        drawer: drawer,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const SingleChildScrollView(
          child: SvecFormWidget(),
        ),
        drawer: drawer,
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
