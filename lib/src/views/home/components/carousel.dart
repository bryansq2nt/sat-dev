import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/providers/banners.dart';
import 'package:sat/src/utilities/showUp.dart';


class CarouselWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BannersProvider>(context);
    final List<Widget> imageSliders = provider.banners.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item.url, fit: BoxFit.cover, width: 1000.0),
                Center(

                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black45,

                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      alignment: Alignment.center,
                      child:  ShowUp(
                        delay: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            Text(item.body, style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                          ],
                        ),
                      )
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: provider.banners.map((item) {
                        int index = provider.banners.indexOf(item);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.current == index
                                ? Color(0xFFFFC300 )
                                : Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    )).toList();

    return provider.status == BannersStatus.Ready ? Column(
        children: [
          CarouselSlider(
            items: imageSliders,

            options: CarouselOptions(

                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
                autoPlayInterval: Duration(seconds: 10),
                autoPlay: true,
                enlargeCenterPage: true,
                pageSnapping: true,
                viewportFraction: 1.0,
                aspectRatio: 16/9,
                onPageChanged: (index, reason) {
                  provider.current = index;
                }
            ),
          ),

        ]
    ) : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center( child: CircularProgressIndicator(),),
    );
  }
}


