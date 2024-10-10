import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sporttvs/tv_channels/tv_channel.dart';
import 'package:sporttvs/tv_channels/tv_channel_player.dart';
import 'package:sporttvs/tv_highlight/match_list_screen.dart';

/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ChannelList(),
    MatchListScreen(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_outlined),
            label: 'Sprots TV Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_rounded),
            label: 'Highlight TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  final List<TVChannel> _channels = [
    TVChannel(
        name: 'MUTV',
        url:
            'https://bcovlive-a.akamaihd.net/r2d2c4ca5bf57456fb1d16255c1a535c8/eu-west-1/6058004203001/playlist.m3u8',
        imagePath: 'assets/mutv.png'),
    TVChannel(
        name: 'Inter TV',
        url:
            'https://open.http.mp.streamamg.com/p/3001560/sp/300156000/playManifest/entryId/0_xmkk2kjr/flavorIds/0_zlbr85f8,0_zlbr85f8,0_noewhew2/format/applehttp/protocol/https/a.m3u8',
        imagePath: 'assets/intertv.png'),
    TVChannel(
        name: 'ФУТБОЛ LIVE ',
        url: 'https://live.teleradiocom.tj/8/3m.m3u8',
        imagePath: 'assets/teleradiocom.png'),
    TVChannel(
        name: 'Alfa Sports',
        url:
            'https://dev.aftermind.xyz/edge-hls/unitrust/alfasports/index.m3u8?token=8TXWzhY3h6jrzqEqx',
        imagePath: 'assets/alfasports.png'),
    TVChannel(
        name: 'Marquee Sports',
        url:
            'https://marqueelive.akamaized.net/live-pz/a/hls-itc/marquee1/index.m3u8',
        imagePath: 'assets/marquee.png'),
    TVChannel(
        name: 'Sports TV',
        url: 'https://live.sportstv.com.tr/hls/low/sportstv.m3u8',
        imagePath: 'assets/sportstv.png'),
    TVChannel(
        name: 'Ottera Sports',
        url: 'https://stream.ads.ottera.tv/playlist.m3u8?network_id=960',
        imagePath: 'assets/ottera.png'),
    TVChannel(
        name: 'Multivision Sports',
        url:
            'https://stream.digitalgt.com:3605/live/multivisionsportslive.m3u8',
        imagePath: 'assets/multivision.png'),
    TVChannel(
        name: 'Colimdo Sports',
        url: 'https://cnn.livestreaminggroup.info:3132/live/colimdotvlive.m3u8',
        imagePath: 'assets/colimdo.png'),
    TVChannel(
        name: 'Canale 88',
        url: 'https://srvx1.selftv.video/dmchannel/live/playlist.m3u8',
        imagePath: 'assets/canale.png'),
    TVChannel(
        name: 'FTV',
        url: 'https://master.tucableip.com/ftv/index.m3u8',
        imagePath: 'assets/ftv.png'),
  ];

  int _currentCarouselIndex = 0;

  final List<String> _carouselImages = [
    'assets/image.png',
    'assets/image1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        // appBar: AppBar(
        //   title: const Text('TV Channel List'),
        //   elevation: 2,
        // ),
        body: Column(
          children: [
            _buildCarouselSlider(),
            const SizedBox(height: 10),
            _buildChannelList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    // Get the device width to dynamically set the height and image scale
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double carouselHeight =
        deviceWidth * 0.37; // Adjust the height ratio for better appearance

    return Column(
      children: [
        CarouselSlider(
          items: _carouselImages.map((imagePath) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit
                      .contain, // Change to cover for better scaling on different devices
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: carouselHeight, // Use the calculated dynamic height
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _changeCarouselIndex(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == entry.key
                      ? Colors.teal
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _changeCarouselIndex(int index) {
    setState(() {
      _currentCarouselIndex = index;
    });
  }

  Widget _buildChannelList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _channels.length,
        itemBuilder: (context, index) {
          final channel = _channels[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TVChannelPlayer(streamUrl: channel.url),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    channel.imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(
                  channel.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
