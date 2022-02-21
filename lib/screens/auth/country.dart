// ignore_for_file: avoid_print, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'login.dart';

class Country extends StatefulWidget {
  final int select;
  Country(this.select, {Key? key}) : super(key: key);
  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  List<Countries> list = countries;
  @override
  Widget build(BuildContext context) {
    print([2, Navigator.canPop(context)]);
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            translate(context, 'country', 'title'),
            style: TextStyle(
                fontSize: w * 0.05,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          leading: widget.select == 1
              ? const SizedBox()
              : const BackButton(
                  color: Colors.black,
                ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
            child: SizedBox(
              width: w * 0.9,
              height: h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: List.generate(list.length, (index) {
                        return Column(
                          children: [
                            SizedBox(
                              width: w * 0.9,
                              height: h * 0.08,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Container(
                                      width: w * 0.1,
                                      height: w * 0.1,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                            // image: AssetImage('assets/kuwait.png'),
                                            image:
                                                NetworkImage(list[index].image),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                    SizedBox(
                                      width: w * 0.03,
                                    ),
                                    Text(
                                      translateString(list[index].nameEn,
                                          list[index].nameAr),
                                      style: TextStyle(
                                        fontSize: w * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Expanded(
                                        child: SizedBox(
                                      width: 1,
                                    )),
                                    if (widget.select == 2)
                                      CircleAvatar(
                                        radius: w * 0.03,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: w * 0.04,
                                        ),
                                        backgroundColor:
                                            countryId == list[index].id
                                                ? mainColor
                                                : Colors.white,
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    setCountryId(list[index].id,
                                        list[index].code, list[index].number);
                                    print(
                                        "\n ${list[index].currencyName.toString()}");
                                    prefs.setString('currencyEn',
                                        list[index].currencyCodeEn.toString());
                                    prefs.setString('currencyAr',
                                        list[index].currencyCodeAr.toString());
                                  });
                                  if (widget.select == 1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            if (list.length - 1 != index)
                              Divider(
                                height: h * 0.005,
                                color: Colors.grey[400],
                              ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: h * 0.1,
                    ),
                    if (widget.select == 2)
                      InkWell(
                        child: Container(
                          height: h * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor,
                          ),
                          child: Center(
                            child: Text(
                              widget.select == 2
                                  ? translate(context, 'buttons', 'save')
                                  : translate(context, 'buttons', 'next'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (countryId != 0) {
                            if (widget.select == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            }
                            if (widget.select == 2) {
                              Navigator.pop(context);
                            }
                          } else {
                            final snackBar = SnackBar(
                              content: Text(
                                  translate(context, 'country', 'choose.txt')),
                              action: SnackBarAction(
                                label: translate(context, 'snack_bar', 'undo'),
                                disabledTextColor: Colors.yellow,
                                textColor: Colors.yellow,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
