import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class TVChannelPlayer extends StatefulWidget {
  final String streamUrl;

  const TVChannelPlayer({super.key, required this.streamUrl});

  @override
  _TVChannelPlayerState createState() => _TVChannelPlayerState();
}

class _TVChannelPlayerState extends State<TVChannelPlayer> {
  late VideoPlayerController _controller;
  bool _isError = false;
  String _errorMessage = '';
  bool _isFullScreen = false;
  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        setState(() {
          _isError = true;
          _errorMessage = 'Error initializing video player: $error';
        });
        print('Error initializing video player: $error');
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _isFullScreen
            ? null // Hide AppBar in full-screen mode
            : AppBar(
                title: const Text('TV Channel Player'),
                backgroundColor: Colors.greenAccent,
                elevation: 0,
              ),
        backgroundColor: Colors.black,
        body: Center(
          child: _isError
              ? _buildErrorUI()
              : _controller.value.isInitialized
                  ? _isFullScreen
                      ? _buildFullScreenVideoPlayer()
                      : _buildMinimizedVideoPlayer()
                  : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 48),
        const SizedBox(height: 16),
        Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isError = false;
              _controller = VideoPlayerController.network(widget.streamUrl)
                ..initialize().then((_) {
                  setState(() {});
                  _controller.play();
                }).catchError((error) {
                  setState(() {
                    _isError = true;
                    _errorMessage = 'Error initializing video player: $error';
                  });
                  print('Error initializing video player: $error');
                });
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildMinimizedVideoPlayer() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        _buildControlsOverlay(),
      ],
    );
  }

  Widget _buildFullScreenVideoPlayer() {
    return Stack(
      children: [
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        _buildControlsOverlay(),
      ],
    );
  }

  Widget _buildControlsOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _toggleControlsVisibility,
        child: Stack(
          children: [
            if (_isControlsVisible)
              Container(
                color: Colors.black54,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 60,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    _buildBottomControls(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.greenAccent,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black45,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
    );
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
