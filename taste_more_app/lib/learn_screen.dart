import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  @override
  LearnScreenState createState() => LearnScreenState();
}

class LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'assets/learn_screen.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Center(
            child: new ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Card(
                  child: new ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnOurTechnologies()));
                      },
                      title: new Text(
                        "Skip the Straw",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnOurTechnologies()));
                      },
                      title: new Text(
                        "Less is More",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnOurTechnologies()));
                      },
                      title: new Text(
                        "Say NO to Extras",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )),
                ), Card(
                  child: new ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnOurTechnologies()));
                      },
                      title: new Text(
                        "Don't be afraid to Ask",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )),
                ),Card(
                  child: new ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnOurTechnologies()));
                      },
                      title: new Text(
                        "Do your part, use this app!",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LearnOurTechnologies extends StatelessWidget {
  String _learnTechnologyDescription =
  '''Combining the latest advances in psychoacoustics and energy medicine, our brainwave synchronization technology - ‘Brain Enhance' features the unique soundtrack, the unique audio equipment and the perfect combination of them. All of these have been carefully engineered and tested to show that they are capable of improving your mind, especially your sleeping, towards a better state.

1. Our soundtracks - Brain Wave Subliminals, are exclusively created by Dr. Mariarosa Greco Ph.D. and Giancarlo Tarozzi, using their 20 years of research, expertise, and experience in integrative medicine and neuroscience. These tracks are imbued with binaural and/or isochronic rhythms, embedded with Delta waves as the first step and Theta and/or Epsilon waves as the second and deeper step, together with subliminal messages from Dr. Mariarosa Greco's voice for even deeper and more effective subconscious re-programming to help you achieve the desired state with greater ease and efficiency. 

2. Our audio equipment - iSS: Equipment is specially developed by a group of talents in vibration and acoustics. It comes from our proprietary bending wave technology, similar to the principal of sound creation through musical instruments, reproduces sound in the purest way with a good grip on high frequencies, a clear midrange and fantastic sense of rhythm to enhance the listener's perception to details in soundtracks as well as the therapeutic effect.

3. The perfect combination of software (iSS: APP) and hardware (iSS: Equipment) maximizes the therapeutic effect by brainwave synchronization, better than any phone APP that is designed just for general use. All soundtracks in our APP have been crafted to align with the iSS: Equipment's frequency response to ensure that messages, tones, and beats can be regenerated with super high fidelity and can be perceived by your brain.

''';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Our Technologies"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: new Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/learn_description.jpg',
                width: 490.0,
                height: 1200.0,
                fit: BoxFit.fill,
              ),
            ),
            new ListView(
              children: <Widget>[
                new ListTile(
                  subtitle: new Text(
                    _learnTechnologyDescription,
                    style: TextStyle(color: Colors.black, fontSize: 19.0),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
