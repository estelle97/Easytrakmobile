import 'dart:async';

import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/userService.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController;
  TextEditingController _passwordController;

  FocusNode _loginNode;
  FocusNode _passwordNode;

  bool _isLoading;
  var _formKey;
  bool _obscureText;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _isLoading = false;
    _obscureText = true;

    allSales = null;
    allPurchases = null;
    allIncomes = null;
    dailySales = null;
    dailyPurchases = null;
    dailyIncomes = null;

    _loginNode = new FocusNode();
    _passwordNode = new FocusNode();

    _loginController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _connectionAttempt() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> params = Map<String, dynamic>();
      params['login'] = _loginController.text;
      params['password'] = _passwordController.text;

      await login(params).then((success) async {
        if (success) {
          await fetchUserDetails(userId).then((user) async {
            if (user != null) {
              await logUserOnFirebase();
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              _retrieveUserDataError();
            }
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorMessage();
        }
      });
    }
  }

  _showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: myHeight(context) / 2.5,
                  child: errorStatusCode == 401
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            errorAlertIcon(context),
                            SizedBox(
                              height: myHeight(context) / 40,
                            ),
                            Text(
                              'Erreur d\'authentification',
                              style: TextStyle(
                                  color: textInverseModeColor,
                                  fontSize: myWidth(context) / 22),
                            ),
                            SizedBox(height: myHeight(context) / 80),
                            Text(
                              'Desole, nous n\'avons pas pu vous',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.5),
                                  fontSize: myWidth(context) / 27),
                            ),
                            Text(
                              'identifier. Votre nom d\'utilisateur',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.5),
                                  fontSize: myWidth(context) / 27),
                            ),
                            Text(
                              'ou mot de passe est incorrecte.',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.5),
                                  fontSize: myWidth(context) / 27),
                            ),
                            SizedBox(
                              height: myHeight(context) / 40,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    borderSide:
                                        BorderSide(color: textInverseModeColor),
                                    onPressed: () => Navigator.pop(context),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40.0,
                                        child: Text('Fermer',
                                            style: TextStyle(
                                              color: textInverseModeColor,
                                            ))),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : errorStatusCode == 404
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                errorAlertIcon(context),
                                SizedBox(
                                  height: myHeight(context) / 40,
                                ),
                                Text(
                                  'Erreur d\'authentification',
                                  style: TextStyle(
                                      color: textInverseModeColor,
                                      fontSize: myWidth(context) / 22),
                                ),
                                SizedBox(height: myHeight(context) / 80),
                                Text(
                                  'Desole, nous n\'avons pas pu vous',
                                  style: TextStyle(
                                      color:
                                          textInverseModeColor.withOpacity(.5),
                                      fontSize: myWidth(context) / 27),
                                ),
                                Text(
                                  'identifier. Votre nom d\'utilisateur',
                                  style: TextStyle(
                                      color:
                                          textInverseModeColor.withOpacity(.5),
                                      fontSize: myWidth(context) / 27),
                                ),
                                Text(
                                  'n\'existe pas dans notre base.',
                                  style: TextStyle(
                                      color:
                                          textInverseModeColor.withOpacity(.5),
                                      fontSize: myWidth(context) / 27),
                                ),
                                SizedBox(
                                  height: myHeight(context) / 40,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: OutlineButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0))),
                                        borderSide: BorderSide(
                                            color: textInverseModeColor),
                                        onPressed: () => Navigator.pop(context),
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 40.0,
                                            child: Text('Fermer',
                                                style: TextStyle(
                                                  color: textInverseModeColor,
                                                ))),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : errorStatusCode == 500
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    errorAlertIcon(context),
                                    SizedBox(
                                      height: myHeight(context) / 40,
                                    ),
                                    Text(
                                      'Erreur de serveur',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontSize: myWidth(context) / 22),
                                    ),
                                    SizedBox(height: myHeight(context) / 80),
                                    Text(
                                      'Desole, nous n\'avons pas pu vous',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.5),
                                          fontSize: myWidth(context) / 27),
                                    ),
                                    Text(
                                      'identifier car Notre serveur est',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.5),
                                          fontSize: myWidth(context) / 27),
                                    ),
                                    Text(
                                      'indisponible pour l\'instant',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.5),
                                          fontSize: myWidth(context) / 27),
                                    ),
                                    SizedBox(
                                      height: myHeight(context) / 40,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: OutlineButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0))),
                                            borderSide: BorderSide(
                                                color: textInverseModeColor),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: 40.0,
                                                child: Text('Fermer',
                                                    style: TextStyle(
                                                        color:
                                                            textInverseModeColor))),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    errorAlertIcon(context),
                                    SizedBox(
                                      height: myHeight(context) / 40,
                                    ),
                                    Text(
                                      'Erreur de connectivite',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontSize: myWidth(context) / 22),
                                    ),
                                    SizedBox(height: myHeight(context) / 80),
                                    Text(
                                      'Desole, nous n\'avons pas pu vous',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.5),
                                          fontSize: myWidth(context) / 27),
                                    ),
                                    Text(
                                      'identifier. Verifier votre acces',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.5),
                                          fontSize: myWidth(context) / 27),
                                    ),
                                    Text(
                                      'internet.',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.5),
                                          fontSize: myWidth(context) / 27),
                                    ),
                                    SizedBox(
                                      height: myHeight(context) / 40,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: OutlineButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0))),
                                            borderSide: BorderSide(
                                                color: textInverseModeColor),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: 40.0,
                                                child: Text('Fermer',
                                                    style: TextStyle(
                                                      color:
                                                          textInverseModeColor,
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
            ));
  }

  _retrieveUserDataError() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: myHeight(context) / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      errorAlertIcon(context),
                      SizedBox(
                        height: myHeight(context) / 40,
                      ),
                      Text(
                        'Erreur d\'authentification',
                        style: TextStyle(
                            color: textInverseModeColor,
                            fontSize: myWidth(context) / 22),
                      ),
                      SizedBox(height: myHeight(context) / 80),
                      Text(
                        'Desole, nous n\'avons pas pu vous',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 27),
                      ),
                      Text(
                        'recuperer toutes vos informations',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 27),
                      ),
                      Text(
                        'veuillez reessayer plus tard.',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 27),
                      ),
                      SizedBox(
                        height: myHeight(context) / 40,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              borderSide:
                                  BorderSide(color: textInverseModeColor),
                              onPressed: () => Navigator.pop(context),
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  child: Text('Fermer',
                                      style: TextStyle(
                                        color: textInverseModeColor,
                                      ))),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                        height: myHeight(context),
                        width: myWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: myHeight(context) / 15.0,
                            ),
                            Hero(
                              tag: 'logo',
                              child: Image.asset(
                                'img/Logo.png',
                                width: myHeight(context) / 13,
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Text('Connexion',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontSize: myHeight(context) / 20)),
                            SizedBox(height: myHeight(context) / 80.0),
                            Text(
                              'Authentifiez-vous pour acceder',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.7),
                                  fontSize: myHeight(context) / 39),
                            ),
                            Text(
                              'a la plate-forme',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.7),
                                  fontSize: myHeight(context) / 39),
                            ),
                            SizedBox(
                              height: myHeight(context) / 18,
                            ),
                            Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                      height: 48,
                                      decoration: buildTextFormFieldContainer(
                                          decorationColor)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    controller: _loginController,
                                    focusNode: _loginNode,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) => nextNode(
                                        context, _loginNode, _passwordNode),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Champs obligatoire';
                                      }
                                      return null;
                                    },
                                    style:
                                        TextStyle(color: textInverseModeColor),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 50.0),
                                        prefixIcon: Icon(
                                            AmazingIcon.user_6_line,
                                            color: textInverseModeColor,
                                            size: 15.0),
                                        hintText: 'Nom d\'utilisateur',
                                        hintStyle: TextStyle(
                                            color: textInverseModeColor
                                                .withOpacity(.35),
                                            fontSize: 18.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: myHeight(context) / 31.0,
                            ),
                            Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.5),
                                  child: Container(
                                      height: 48,
                                      decoration: buildTextFormFieldContainer(
                                          decorationColor)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    obscureText: _obscureText,
                                    controller: _passwordController,
                                    focusNode: _passwordNode,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      _passwordNode.unfocus();
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Champs obligatoire';
                                      }
                                      return null;
                                    },
                                    style:
                                        TextStyle(color: textInverseModeColor),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 50.0),
                                        prefixIcon: Icon(
                                            AmazingIcon.lock_password_line,
                                            color: textInverseModeColor,
                                            size: 15.0),
                                        hintText: 'Mot de passe',
                                        fillColor: textInverseModeColor,
                                        hintStyle: TextStyle(
                                            color: textInverseModeColor
                                                .withOpacity(.35),
                                            fontSize: 18.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () => _toggle(),
                                          child: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: textInverseModeColor,
                                              size: 15.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: myHeight(context) / 31.0,
                            ),
                            InkWell(
                              onTap: () => _connectionAttempt(),
                              child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [gradient1, gradient2])),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Center(
                                      child: Text(
                                        'Se connecter',
                                        style: TextStyle(
                                            color: textSameModeColor,
                                            fontSize: 18),
                                      ),
                                    ),
                                  )),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 10.0),
                              child: Container(
                                height: myHeight(context) / 10,
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/register'),
                                      child: Container(
                                          child: Text('Inscription',
                                              style: TextStyle(
                                                  color: textInverseModeColor,
                                                  fontSize:
                                                      myHeight(context) / 43))),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      /*  onTap: () {
                                        setState(() {
                                          appThemeMode =
                                              appThemeMode == ThemeMode.dark
                                                  ? ThemeMode.light
                                                  : ThemeMode.dark;
                                          loadModeColor(appThemeMode);
                                        });
                                        changeMode(appThemeMode == ThemeMode.dark
                                            ? true
                                            : false);
                                      }, */
                                      onTap: () => Navigator.pushNamed(
                                          context, '/recover'),
                                      child: Text('Mot de passe oublie',
                                          style: TextStyle(
                                              color: textInverseModeColor,
                                              fontSize:
                                                  myHeight(context) / 43)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              _isLoading
                  ? Container(
                      width: myWidth(context),
                      height: myHeight(context),
                      color: textSameModeColor.withOpacity(.89),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(gradient1),
                        ),
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
