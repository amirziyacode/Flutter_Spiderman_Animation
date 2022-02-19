import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
      
  final _springdDescription = const SpringDescription(
    mass: 1.0,
    stiffness: 500.0,
    damping: 15.0,
  );

  Offset _thumbOffset = Offset.zero;
  Offset? _anchorPosition;
  Offset _previousVelocity = Offset.zero;

  SpringSimulation? _startSpringX;
  SpringSimulation? _startSpringY;
  Ticker? _ticker;

  // TODO void for start ...
  void _onPanStart(DragStartDetails details) {
    _endSpring();  
    }

  // TODO void for Update Animation ...
  void _onPanUpadte(DragUpdateDetails details) {
    setState(() {
      _thumbOffset += details.delta;
    });
  }

  // TODO for get position of the user ... 
  void _onTapUP(TapUpDetails details) {
    setState(() {
      _anchorPosition = details.localPosition;
      _endSpring();
      _startSpring();
    });
  }

  // TODO void for End .. 
  void _onPanEnd(DragEndDetails details) {
    _startSpring();
  }


  // TODO State Animation ... 
  void _startSpring() {
    _startSpringX = SpringSimulation(
        _springdDescription, _thumbOffset.dx,_anchorPosition!.dx, _previousVelocity.dx);
    _startSpringY = SpringSimulation(
        _springdDescription, _thumbOffset.dy, _anchorPosition!.dy, _previousVelocity.dy);
    // final position = _springSimulation.x();

    _ticker ??= createTicker(_ontick);
    _ticker!.start();
  }

  // TODO for onclik ...
  void _ontick(Duration elapsedTime) {
    final elapsSecoundFraction = elapsedTime.inMilliseconds / 1000.0;

    setState(() {
      _thumbOffset = Offset(_startSpringX!.x(elapsSecoundFraction),
          _startSpringY!.x(elapsSecoundFraction));
       _previousVelocity = Offset(
         _startSpringX!.dx(elapsSecoundFraction),
         _startSpringY!.dx(elapsSecoundFraction)
         );   
    });

    _startSpringX!.x(elapsSecoundFraction);

    if (_startSpringX!.isDone(elapsSecoundFraction) &&
        _startSpringY!.isDone(elapsSecoundFraction)) {
      _endSpring();
    }
  }
  
  // TODO End void ... 
    void _endSpring() {
    if (_ticker != null) {
      _ticker!.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    // TODO When the anchorOffset == null and the
    // ! if anchoroffest is null return to SizedBox .. 
    if (_anchorPosition == null) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        RenderBox box = context.findRenderObject() as RenderBox;
        if (box.hasSize) {
          setState(() {
            _anchorPosition = box.size.center(Offset.zero);
            _thumbOffset = _anchorPosition!;
          });
        }
      });
      return const SizedBox();
    }

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light, // TODO : light & dark for mobile ... 
      child: GestureDetector(
        onTapUp: _onTapUP,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpadte,
        onPanEnd: _onPanEnd,
        child: Stack(
          children: [
            _buildbackground(),
            CustomPaint(
              painter: WebPainter(
                  springOffset: _thumbOffset, anchorOffset: _anchorPosition!),
              size: Size.infinite,
            ),
            Transform.translate(
              offset: _thumbOffset,
              child: FractionalTranslation(
                  translation: const Offset(-0.5, -0.5),
                  child: _builSpiderman()),
            )
          ],
        ),
      ),
    );
  }

  // ! for background App ...
  Widget _buildbackground() {
    return SizedBox.expand(
      child: Image.asset(
        "asstes/pexels-chait-goli-2742049 3.03.22 PM.jpg",
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.6),
        colorBlendMode: BlendMode.multiply,
      ),
    );
  }

  // ! for small Spiderman
  Widget _builSpiderman() {
    return SizedBox(
      width: 64,
      height: 64,
      child: Image.asset(
          "asstes/Spiderman Head SVG | Hero Spiderman Head svg cut file Download | JPG, PNG, SVG, CDR, AI, PDF, EPS, DXF Format 3.03.20 PM.png"),
    );
  }
}



// * custom paint for spider man ... //

class WebPainter extends CustomPainter {
  final Offset springOffset; 
  final Offset anchorOffset;
  
   // TODO : make a Line for spider man => ...  
  final Paint springPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  WebPainter({required this.springOffset, required this.anchorOffset});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(anchorOffset, springOffset, springPaint);
  }

  @override
  bool shouldRepaint(WebPainter oldDelegate) {
    return anchorOffset != oldDelegate.anchorOffset ||
        springOffset != oldDelegate.springOffset;
  }
}
